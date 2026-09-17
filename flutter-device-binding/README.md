> Exported from azuma's monorepo at `566f9b94`. The specification pages the text links to
> are under `docs/spec/`.

# azuma DOA - Flutter device-binding example

A customer-facing Android and iOS app that registers and signs in against the DOA Device Binding API with a
hardware-bound device key, mandatory biometrics, fixed 10-minute sessions and Play Integrity - the
account lifecycle a DiGA needs under **BSI TR-03161-1**. Email, passkey and Health-ID are alternative
entry points into the same account; a second device is added through passkey or Health-ID.

> **Android and iOS.** Every hardware-backed part is native on both: the AndroidKeyStore and Play
> Integrity on one side, App Attest and the Secure Enclave on the other. The two are not symmetric and
> the Dart layer knows it - see [Platforms](#platforms).

## Contents

- [Quickstart](#quickstart)
- [What you need](#what-you-need)
- [Platforms](#platforms)
- [Configuration](#configuration) - every define, property and tenant setting in one table
- [What the app does](#what-the-app-does) - and the [`docs/`](docs/) page per journey
- [Verifying a change](#verifying-a-change)
- [Troubleshooting](#troubleshooting)
- [Regenerating the API client](#regenerating-the-api-client)
- [Layout](#layout)

## Quickstart

```bash
flutter pub get
cp config.example.json config.json        # required: put your tenant in; the example holds azuma's demo values
flutter run --dart-define-from-file=config.json
```

Then on a **physical phone** with a fingerprint or strong face unlock enrolled: *Create account* ->
*Register with email*, verify the code from the mail, *Sign in with email*, *Enable biometrics*. You are
in. After ten minutes the app locks and only biometrics reopen it.

Three things stop this working out of the box, none of them code:

- **An emulator cannot register.** Registration sends a hardware key attestation; DOA rejects the
  software attestation an emulator produces. Emulators are fine for `flutter test` and for looking at
  screens, not for any flow that reaches the backend.
- **Self-registration may be disabled on the tenant.** A tenant that answers `RegistrationNotPossible`
  needs email registration enabled, or an existing account plus a passkey or Health-ID to add this
  device with.
- **Health-ID is off until configured.** Its button explains that in the UI. See
  [Configuration](#configuration).

`config.json` is git-ignored. Every value is a compile-time constant (`String.fromEnvironment`), so a
change means a rebuild, and a build cannot be repointed afterwards.

## What you need

| | Required for |
|---|---|
| Flutter 3.35+ (developed on 3.47.1 / Dart 3.13), JDK 17, Android SDK - `flutter doctor` green | building |
| Physical Android device, **API 28+**, lock screen set, **strong biometrics enrolled**, Google Play services present | anything that reaches the backend |
| A DOA tenant with an application registration, and the tenant settings [below](#tenant-settings) | anything that reaches the backend |
| Google Cloud project linked to the app in the Play Console | Play Integrity enforcement on the tenant (the token is sent regardless) |
| `assetlinks.json` on the tenant's passkey RP domain, listing this package + your signing certificate | passkeys |
| Health-ID broker registration (client id, endpoints, callback domain with `assetlinks.json`) | Health-ID |
| Upload keystore (`android/key.properties`) | release builds for Play; a plain checkout falls back to the debug key |
| A Mac with Xcode, an Apple team with App Attest and Associated Domains on the App ID | iOS |

## Platforms

Both phones bind a device and run the same journeys, but DOA verifies two different proofs and the app
sends what each platform can actually produce.

| | Android | iOS |
|---|---|---|
| Device key | EC P-256 in the AndroidKeyStore | App Attest key, which the app never holds |
| Proof of that key | attestation certificate chain | attestation object, plus the key id as `iosHardwareKey` |
| Request signature | `SHA256withECDSA` over the payload | CBOR App Attest assertion over the same bytes |
| Device integrity | a Play Integrity token per binding and per login | the request's own assertion; nothing extra is sent |
| Biometric key | KeyStore key, attested, invalidated when enrolment changes | Secure Enclave P-256 with `.biometryCurrentSet`, no attestation exists |
| Passkeys | Credential Manager, WebAuthn JSON passed through | AuthenticationServices, JSON rebuilt field by field |
| Store | AES-GCM under an RSA KeyStore key | keychain, `ThisDeviceOnly` |
| Health-ID callback | App Link on the callback domain | universal link, same domain and path |

The native code sits beside the app on both sides: `android/app/src/main/kotlin/.../flutter/` and
`ios/Runner/Channels/`. The method names and arguments match one for one, so a channel can be read in
either language against the same Dart file.

Running on an iPhone needs the App Attest and Associated Domains entitlements, a signing identity for
your team, and the tenant's `AppleDeviceAttestationData.TeamBundleIdentifier` set to
`<team id>.com.doa.example.devicebinding.flutter`. `Info.plist` declares
`ITSAppUsesNonExemptEncryption` as `false`: the app ships no cryptography of its own and uses only TLS
and the platform's, which is exempt.

## Configuration

### Dart defines (`config.json`)

| Key | Default | Required for | Notes |
|---|---|---|---|
| `PROFILE` | - (launcher) | reviewed builds | `customer` pins the flow: no launcher, opens on the welcome screen. Unset shows screen 0 |
| `DOA_BASE_URL` | required | everything | Must be `https`. An `http://10.0.2.2:...` local stack works from an emulator but the emulator cannot register |
| `DOA_APPLICATION_ID` | required | everything | The tenant's application registration |
| `PLAY_INTEGRITY_CLOUD_PROJECT_NUMBER` | required | every registration and login | The Cloud project linked to this app in the Play Console. Use your own |
| `HEALTH_ID_AUTHORIZATION_URL` | - | Health-ID | HTTPS broker authorization endpoint supporting `response_format=json` |
| `HEALTH_ID_TOKEN_URL` | - | Health-ID | HTTPS authorization-code exchange endpoint |
| `HEALTH_ID_EXCHANGE_URL` | - | Health-ID | HTTPS mobile broker callback exchange endpoint |
| `HEALTH_ID_CLIENT_ID` | `d0fe4fb5-…` | Health-ID | Registered public mobile client id; no secret |
| `HEALTH_ID_IDP_LIST_URL` | `…/api/v1/idps` | Health-ID | The broker's provider directory, read when the picker opens |
| `HEALTH_ID_RELYING_PARTY_ID` | - | Health-ID | Whose provider list to ask for; comes with the client registration |
| `HEALTH_ID_REDIRECT_URI` | `…/rn-ce/code/ce` | Health-ID | Registered HTTPS app link; must match the two Gradle properties below exactly |
| `HEALTH_ID_AUTHENTICATOR_SCHEME` | `https` | Health-ID | Scheme the broker's launch URL uses |
| `HEALTH_ID_EXCHANGE_VIA_REDIRECT` | `true` | Health-ID | `true` exchanges the full callback URL; `false` sends code + state |
| `TRANSFER_PROVIDER_NAME` | - | account transfer | What the previous app is called, for the screens. Display only |
| `TRANSFER_AUTHORIZATION_URL` | - | account transfer | The previous provider's HTTPS authorization endpoint |
| `TRANSFER_TOKEN_URL` | - | account transfer | Its HTTPS token endpoint |
| `TRANSFER_CLIENT_ID` | - | account transfer | The OAuth client registered for **this app**, with the redirect below. Must also be in the tenant's `ValidAudiences` |
| `TRANSFER_REDIRECT_URI` | `…/callback/transfer` | account transfer | Registered HTTPS app link; must match the two Gradle properties below exactly |
| `TRANSFER_SCOPE` | `openid email` | account transfer | `email` is what lets a transferred account keep a DOA-native way in |
| `TRANSFER_DOA_PROVIDER` | `google` | account transfer | Which DOA route validates the token: `google` or `apple`, the only two DOA has |

The Health-ID flow is disabled until every Health-ID key is HTTPS or non-empty (`HealthId.configured`).
The committed defaults point at the Mimoto reference environment; the user picks the insurer from the
broker's directory when the flow starts, so no provider is pinned into the build. That list is public
and read-only: opening the picker sends no challenge, no token and nothing about the user.

The default Health-ID callback belongs to azuma's React Native example: providers federated through
gematik accept only the callbacks the federation already lists, and that one is listed. With both
example apps installed, only one of them receives the callback. For your own app, register your own
callback domain and publish its association files.

### Account transfer (variant A)

Sign in once at the app the user is leaving, and azuma creates an account for that identity and binds
it to this phone: A1 explains what moves and takes consent, the hand-off runs in the system browser, A2
confirms the identity that came back, and the record keeps `transferredFrom` and the date. The journey
is [`lib/src/customer/journeys/transfer.dart`](lib/src/customer/journeys/transfer.dart); the hand-off is
[`lib/src/core/transfer_provider.dart`](lib/src/core/transfer_provider.dart). Specified as variant A in
[`docs/spec/variants.md`](docs/spec/variants.md).

**It is hidden until `TRANSFER_*` is configured, and it can only be pointed at Google or Apple**, the two
providers whose tokens DOA validates (`account/register/{google,apple}`). To run it, three things have
to exist outside this repository:

1. An OAuth client for this app whose redirect URI is `TRANSFER_REDIRECT_URI`.
2. That client id in the tenant's `GoogleOidcData.ValidAudiences`, with `GoogleTeRegistrationEnabled`
   and `GoogleTeLoginEnabled` on.
3. The redirect claimed by the app on both platforms: Android through `transferCallbackHost` /
   `transferCallbackPath` (the manifest's second app-link filter), iOS through the associated domain's
   `apple-app-site-association`.

In practice neither Google nor Apple issues a public client with an https redirect and no secret, so
the browser hand-off runs end to end today only with Health-ID standing in as the previous provider, or
in demo mode. What is tested is what the app does with an identity once it has one
(`test/transfer_flow_test.dart`).

**Demo mode.** `"TRANSFER_DEMO": true` in `config.json`, in a **debuggable build only** (a release build
folds the path away whatever the define says), shows the transfer screens with no provider at all: an
in-app sheet accepts anything typed, A2 shows it, and "Create my account (demo)" ends with a notice
instead of contacting DOA. Nothing is minted and nothing is written; every demo screen says it is one.

After a transfer the account needs a DOA-native way in before the provider is retired - the e-mail the
provider supplied, or a passkey added on the account screen.

### The phone-key profile (variant C)

The lightest account DOA supports: a username and a password once, and from then on this phone signs
the user in. `auth/login/id` takes the account id and is authenticated by the bound device key alone -
no password, no identity token, nothing to phish.

**What makes it honest is the key, not the UI.** In this profile the *device key itself* is created
with user authentication required, strong biometrics only, invalidated when enrolment changes, and
valid for 600 seconds after one authentication. Signing does not ask the app's permission: the keystore
throws `UserNotAuthenticatedException`, the channel raises the prompt, and only then does the signature
happen ([`DeviceBindingChannel.kt`](android/app/src/main/kotlin/com/doa/example/devicebinding/flutter/DeviceBindingChannel.kt)).
Because a time-bound key counts *any* strong-biometric authentication in its window - unlocking the
phone included - the journey also runs the prompt itself at every session start (`DeviceBinding.unlock`)
and only then signs: the prompt is what the session promises, the keystore is what refuses a signature
without it.

| | |
|---|---|
| Registration | `account/register/username` - no biometric asked: creating a gated key needs no authentication and the request is unsigned. The first prompt is C2's "Unlock", the first sign-in |
| Every login | `challenge/login` -> the fingerprint prompt, run by the journey every session -> `auth/login/id`, signed by the gated key, device-bound, with integrity data |
| Another phone | username and password once on the new phone (`device/register/username`), or a passkey added on the account screen |
| Screens | C1, C2, a lighter account screen and an unlock screen ([`phone_key_views.dart`](lib/src/customer/views/phone_key_views.dart)) |
| Record | `username` instead of an e-mail; no separate biometric key, because there is no second key |

Run it with `--dart-define=PROFILE=phone-key`, or pick **Phone key** on the launcher.

**Android only.** The iOS device key is an App Attest key, which cannot be biometric-gated, so the flow
refuses on iOS and says why rather than gating in software and calling it hardware-enforced. And what
the server verifies is one factor: the biometric gating is written into the key's attestation chain,
which DOA does not read yet.

### Gradle properties (`android/gradle.properties` or `-P`)

| Property | Default | Notes |
|---|---|---|
| `healthIdCallbackHost` | `example.invalid` | Host of `HEALTH_ID_REDIRECT_URI`; becomes the manifest app-link filter |
| `healthIdCallbackPath` | `/health-id/callback` | Path of `HEALTH_ID_REDIRECT_URI` |
| `transferCallbackHost` | `example.invalid` | Host of `TRANSFER_REDIRECT_URI`; becomes the second manifest app-link filter |
| `transferCallbackPath` | `/callback/transfer` | Path of `TRANSFER_REDIRECT_URI` |

The callback domain needs an Android App Links `assetlinks.json` for this package and your signing
certificate, or Android opens the callback in the browser instead of the app.

### Tenant settings

Configured in DOA admin for the tenant that owns `DOA_APPLICATION_ID`.

| Setting | Value | Required for |
|---|---|---|
| Access-token lifetime | 10 minutes | the session policy - the app caps locally to 10 minutes regardless, and to the token's `exp` if shorter |
| `AuthOptions.EmailRegistrationEnabled`, `EmailLoginEnabled` | `true` | email journey |
| `AuthOptions.PasskeysRegistrationEnabled`, `PasskeysLoginEnabled` | `true` | passkeys |
| `AuthOptions.HealthIdRegistrationEnabled`, `HealthIdLoginEnabled` | `true` | Health-ID |
| `AuthOptions.BiometricsLoginEnabled` | `true` | biometrics - mandatory in this app, so effectively required |
| `PasskeysOptions.Domain` | the RP domain hosting `assetlinks.json` | passkeys |
| `GoogleDeviceAttestationOptions.AllowedSecurityLevels` | drop `Software` | attestation to mean anything - the software root's private key is public in AOSP |
| `GoogleDeviceIntegrityData.PackageName` | `com.doa.example.devicebinding.flutter` | Play Integrity enforcement |
| `GoogleDeviceIntegrityServiceAccount` | service-account JSON with Play Integrity API access to the Cloud project | Play Integrity enforcement |
| `GoogleDeviceAttestationOptions.ValidateIntegrity` | `true` | Play Integrity on registration and new devices |
| `AuthOptions.EmailValidateIntegrityOnLogin`, `HealthValidateIntegrityOnLogin`, `PasskeysValidateIntegrityOnLogin`, `BiometricsValidateIntegrityOnLogin` | `true` | Play Integrity on logins |
| `GoogleDeviceIntegrityOptions.ValidateDeviceIntegrity`, `ValidateAppIntegrity` | `true` (defaults) | `ValidateAppIntegrity` requires `PLAY_RECOGNIZED`, so only Play-delivered builds pass |

Every Play Integrity enforcement switch defaults to off; the app sends tokens either way. A tenant holds
one package name.

## What the app does

One screen, gated by state - there are no routes to reach a signed-in view without a session. The
screens are the ones in the [customer app specification](docs/spec/customer-app.md) (numbers
are the design-canvas numbers):

```
storage unreadable  ->  S0 "Retry"                    (fail closed; never silently a fresh install)
session ended       ->  7  lock screen                 (unlock with biometrics, or sign out)
no session          ->  1 welcome -> 2a create account / 2b sign in (new phone) / 2c sign in (linked)
                        -> 3 email registration / 5 email sign-in
email unverified    ->  4  verification code
no biometric key    ->  6  "Enable biometrics"         (cannot be skipped)
blocking action     ->  S1 maintenance message
device check failed ->  S2 full-screen state         (Check again re-runs the action)
password required   ->  9  change password
otherwise           ->  8  account & security          (9 reachable from here)
```

Unpinned builds open on **screen 0**, a launcher listing the customer flow and the
[variants](docs/spec/variants.md). Each flow has its own device record, so they behave like
separate installs. `--dart-define=PROFILE=customer` removes the launcher and opens on screen 1; that is
the binary to review.

Each journey has a page under [`docs/`](docs/) with the screens, the API calls in order (with their
challenge kinds), what is persisted, what the server checks and which test pins it:

| Journey | Page |
|---|---|
| Architecture: layers, native channels, session, storage, integrity, library decisions | [docs/architecture.md](docs/architecture.md) |
| Create an account - email, passkey, Health-ID | [docs/journeys/registration.md](docs/journeys/registration.md) |
| Sign in on a bound device - email, passkey, Health-ID, biometrics | [docs/journeys/login.md](docs/journeys/login.md) |
| Mandatory biometric setup and the 10-minute renewal | [docs/journeys/biometrics.md](docs/journeys/biometrics.md) |
| Add a second device - passkey or Health-ID only | [docs/journeys/second-device.md](docs/journeys/second-device.md) |
| Account & security - profile, link Health-ID, add passkey, change password, sign out | [docs/journeys/account.md](docs/journeys/account.md) |
| Health-ID broker flow in detail | [docs/journeys/health-id.md](docs/journeys/health-id.md) |
| Account transfer (variant A) | [docs/journeys/transfer.md](docs/journeys/transfer.md) |
| Phone key (variant C) | [docs/journeys/phone-key.md](docs/journeys/phone-key.md) |

Policies that hold everywhere: no `offline_access`, no refresh token retained, access token in memory
only, restart always requires login; secure storage holds identifiers (key aliases, account id, email,
verification flow) and never a password or token; every registration and login carries a Play Integrity
token over its server challenge; the biometric key is attested over its linking challenge.

## Verifying a change

```bash
flutter analyze --no-pub
flutter test --no-pub                      # 72 tests, no device needed
flutter build apk --debug --no-pub
flutter build apk --release --no-pub       # R8 on; catches things the debug build hides
flutter build apk --release --no-pub --dart-define=PROFILE=customer   # the reviewed binary
```

After the pinned release build, confirm the launcher and DevTools are gone from the artefact:
`DOA example flows` and `Force-expire session` must not appear in any `libapp.so` inside the APK.

The tests fake the native channels and the API; they prove ordering, payloads, persistence and the
fail-closed paths. Attestation, integrity verdicts and authenticator interoperability need a phone, a
configured tenant and the release build.

## Troubleshooting

| Symptom | Cause | Fix |
|---|---|---|
| Registration fails with an attestation error on an emulator | Emulators produce a software attestation; DOA rejects it | Use a physical device, or a tenant whose `AllowedSecurityLevels` includes `Software` for local development only |
| `RegistrationNotPossible` | Email registration disabled on the tenant | Enable it, or add this device to an existing account via passkey / Health-ID |
| "The device check with Google Play could not be completed" | Play services missing/outdated, offline, or the Cloud project not linked | Update Play services; link the project in the Play Console; check `PLAY_INTEGRITY_CLOUD_PROJECT_NUMBER` |
| "Google Play could not confirm that this device and app are unmodified" | The tenant enforces integrity and the verdict failed - rooted/unlocked device, sideloaded build with `ValidateAppIntegrity`, or a stale token | Expected on a modified device. For sideloaded test builds, turn off `ValidateAppIntegrity` on the test tenant |
| "This app requires strong biometrics" | No fingerprint / strong face enrolled, or the device has only weak biometrics | Enrol one in device settings |
| Passkey creation fails only on testers' phones, or on yours after a re-install; logcat shows `RP ID cannot be validated`; the app says "Passkeys aren't available in this build" | The build is signed by a certificate not listed for **this package name** in the RP's `assetlinks.json`. Play re-signs uploads, so a build from Play carries a different certificate than one from `adb install` | List every certificate a build can carry: your upload or debug key (`keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android`), the Play app-signing key (Play Console -> App integrity), and the internal-app-sharing key if you use that path |
| Health-ID callback opens in the browser, app never returns | App Links verification failed: `assetlinks.json` missing on the callback domain, or host/path do not match `HEALTH_ID_REDIRECT_URI` | Publish the association; make the Gradle properties match the redirect URI exactly |
| `MissingPluginException` on a `com.doa.example...` channel | Dart and Kotlin channel names drifted, or the app is hosted without `MainActivity` | The names are plain strings on both sides - grep for the channel constant |
| "Secure storage could not be read. Retry before continuing." | The RSA-4096 wrapping key is gone (keystore reset, restore to other hardware) or the store file is corrupt | Deliberate: the app never treats this as a fresh install. Reinstall to start over |
| First write after install is slow | The TEE generates the RSA-4096 wrapping key on first launch | Expected once; measured in seconds on some devices |
| Release `appbundle` on Windows: "failed to strip debug symbols" | Known Flutter/NDK issue | The `.aab` is still produced and valid; check the file, not the exit message |
| Release build behaves differently from debug | R8 renamed something loaded reflectively | `android/app/proguard-rules.pro` keeps Tink and `androidx.credentials`; add a keep if you introduce another reflective library |

## Regenerating the API client

`generated/doa_device_binding_api/` is OpenAPI-generator output from the checked-in `swagger.json`
(refresh that from `https://<host>/api/docs/doa/deviceBinding_v1/swagger.json` first). Never hand-edit
it.

```bash
npx @openapitools/openapi-generator-cli generate -c openapi-generator-config.yaml
cd generated/doa_device_binding_api && dart pub get && dart run build_runner build
```

Two paths are `.openapi-generator-ignore`d: the package `pubspec.yaml` (the template pins language
version 3.5, which current `json_serializable` output cannot compile against; run `flutter pub get` in
the app after changing it) and the generated `test/` stubs.

The customer journey posts raw maps through `DeviceBoundApi`, not the generated request models, so it
tolerates fields the client has not been regenerated for - which is how it already sends the
`keyAttestation` field.

## Layout

```
lib/
  main.dart                  opens the AndroidKeyStore, applies a debug-only override, runs the app
  src/app_config.dart        the compile-time defines + RuntimeConfig; PROFILE pin
  src/theme/                 azuma tokens (app_colors.dart) mapped onto Material 3 (app_theme.dart)
  src/start/start_screen.dart screen 0, the launcher; only reachable in unpinned builds
  src/core/                  THE REUSABLE PART - see its README. No UI, no policy:
    device_binding.dart        device key + attestation chain + payload signing; the gated key and
                               its prompt for the phone-key profile
    biometric_binding.dart     biometric-gated, attested key; prompt-and-sign in one call
    passkey_manager.dart       Credential Manager / AuthenticationServices, opaque JSON in and out
    play_integrity.dart        Play Integrity standard requests (Android)
    secure_store.dart          RSA-4096-wrapped AES-256-GCM values (Android), keychain (iOS); fail-closed reads
    health_id.dart             the Health-ID broker round trip
    transfer_provider.dart     variant A's previous-provider hand-off, and its demo mode
    device_bound_api.dart      URL shape and the signed envelope
    device_os.dart             which platform this is, and how DOA names it
  src/customer/              THE CUSTOMER JOURNEY - this tenant's policy on the core:
    customer_controller.dart   state + shared rules; one `part` per journey in journeys/
    journeys/                  registration, login, biometrics, second_device, account, transfer, phone_key
    scenario.dart              the flows the launcher lists and which storage slot each uses
    customer_screen.dart       the state gate, entry/account sub-steps, lifecycle, app bar
    views/                     one file per screen group: entry (1, 2a-c), email (3-5), gate (S0, 6, S1, 7),
                               account (8, 9, 9b), transfer (A1, A2, the demo sheet), phone_key (C1, C2,
                               8-lite), provider_picker (H1), safety (S3)
    widgets/widgets.dart       MethodTile, NoticeBanner, InfoBanner, StrengthMeter, HeroCircle, ProofLine, SectionLabel
    notice.dart                Notice {tone, title, body, retry}: what the app says about an outcome, and where
    customer_session.dart      the 10-minute session; customer_storage.dart: the one record per slot
    devtools/                  debug builds only - inspector, reset, override; absent from release
android/app/src/main/kotlin/com/doa/example/devicebinding/flutter/
  DeviceBindingChannel.kt    device key: generate with attestation challenge (biometric-gated for the
                             phone-key profile), export chain, sign, prompt
  BiometricBindingChannel.kt biometric-gated key with attestation; BiometricPrompt + CryptoObject signing
  PasskeyChannel.kt          Credential Manager, opaque JSON in and out
  IntegrityChannel.kt        Play Integrity standard requests
  SecureStoreChannel.kt      AES-256-GCM values under an RSA-4096 AndroidKeyStore wrapping key
  HealthIdChannel.kt         PKCE proof and the browser hand-off for an OAuth callback (Health-ID and the transfer)
  CertificateChainEncoding.kt the one wire encoding for attestation chains
ios/Runner/Channels/         the same channels in Swift: App Attest, Secure Enclave, AuthenticationServices,
                             keychain, universal-link hand-off
generated/doa_device_binding_api/   OpenAPI output
docs/                        architecture, journeys/ index + one page per journey
test/                        72 tests: customer_flow_test.dart (the journey suite), transfer_flow_test.dart,
                             phone_key_flow_test.dart, navigation_test.dart, widget_test.dart (the screens),
                             customer_api_test.dart, health_id_proof_test.dart
assets/fonts/                Figtree (OFL), the corporate typeface
```

**Debug builds** name the Health-ID step they are on (`health-id: requesting the token`), the host and
path of a callback they received and the backend's error code when a request is refused - never a
token, a challenge or a query string. `adb logcat | grep -E "health-id:|outcome:|doa rejected"` is the
whole flow in one screen. The bug icon in the app bar opens DevTools: a state inspector, the raw profile
with per-credential **Unlink**, **Force-expire session**, **Reset local state**, and a runtime override
of base URL and application id applied at the next start. All of it is behind `kDebugMode`, a
compile-time constant; release builds carry neither the strings nor the screen, and cannot be
repointed.
