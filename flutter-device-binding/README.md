> Exported from azuma's monorepo at `98b83b0e`. The specification pages the text links to
> are under `docs/spec/`.

# azuma DOA - Flutter device-binding example

A customer-facing Android and iOS app that registers and signs in against the DOA Device Binding API with a
hardware-bound device key, mandatory biometrics, fixed 10-minute sessions and Play Integrity - the
account lifecycle a DiGA needs under **BSI TR-03161-1**. Email, passkey and Health-ID are alternative
entry points into the same account; a second device is added through passkey or Health-ID.

It is **not claimed BSI-conformant or certified**. The
[conformance checklist](docs/spec/conformance-checklist.md) is the honest state: which controls
exist, what the tests prove, and what still needs a device, a tenant or an evaluator. Two backend gaps it depends on - bounding the age of the integrity token, and reading the biometric
key's attestation - are tracked on the backend; the app already sends what
those will check.

> **Android and iOS.** Every hardware-backed part is native on both: the AndroidKeyStore and Play
> Integrity on one side, App Attest and the Secure Enclave on the other. The two are not symmetric and
> the Dart layer knows it - see [Platforms](#platforms). The separate Swift sample,
> `ios-device-binding` in azuma's monorepo, is the older 1:1 port and not this app.

## Contents

- [Quickstart](#quickstart)
- [What you need](#what-you-need)
- [Configuration](#configuration) - every define, property and tenant setting in one table
- [What the app does](#what-the-app-does) - and the [`docs/`](docs/) page per journey
- [Verifying a change](#verifying-a-change)
- [Troubleshooting](#troubleshooting)
- [Releasing to testers via Google Play](#releasing-to-testers-via-google-play)
- [Releasing to testers via TestFlight](#releasing-to-testers-via-testflight)
- [Regenerating the API client](#regenerating-the-api-client)
- [Layout and status](#layout-and-status)

## Quickstart

```bash
cd examples/flutter-device-binding
flutter pub get
cp config.example.json config.json        # required: put your tenant in; the example holds azuma's demo values
flutter run --dart-define-from-file=config.json
```

Then on a **physical phone** with a fingerprint or strong face unlock enrolled: *Create account* ->
*Register with email*, verify the code from the mail, *Sign in with email*, *Enable biometrics*. You are
in. After ten minutes the app locks and only biometrics reopen it.

Three things stop this working out of the box, none of them code:

- **An emulator cannot register.** Registration sends a hardware key attestation; pie rejects the
  software attestation an emulator produces. Emulators are fine for `flutter test` and for looking at
  screens, not for any flow that reaches the backend.
- **Self-registration may be disabled on the tenant.** pie currently answers `RegistrationNotPossible`;
  you need an environment where email registration is enabled, or an existing account plus a passkey or
  Health-ID to add this device with.
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

**Building for iOS needs a Mac.** There is none on the team, so every pull request that touches `ios/`
or `lib/` gets an unsigned compile check on a GitHub macOS runner
(see [Releasing to testers via TestFlight](#releasing-to-testers-via-testflight)). Unsigned proves the Swift
compiles and links, nothing more. Running on a device additionally needs the App Attest entitlement,
the Associated Domains entitlement and a signing identity for team `CRWTAA276J`, and the tenant needs
`AppleDeviceAttestationData.TeamBundleIdentifier` set to
`CRWTAA276J.com.doa.example.devicebinding.flutter`.

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
| `HEALTH_ID_REDIRECT_URI` | `…/rn-ce/code/ce` | Health-ID | Registered HTTPS app link; must match the two Gradle properties below exactly. Borrowed from the React Native example - see [The borrowed callback](#the-borrowed-callback) |
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
The committed defaults point at the Mimoto reference environment. Do not reuse the React Native
example's Mimoto client ids; they are not registered for this package.

The user picks the insurer from the broker's directory when the flow starts, so no provider is pinned
into the build. That list is public and read-only: opening the picker sends no challenge, no token and
nothing about the user.

### The borrowed callback

The Health-ID callback is `https://mimoto-example-app.azuma-health.tech/rn-ce/code/ce`, which belongs
to the React Native example, and that is deliberate.

A provider federated through gematik does not read the broker's client registration. It resolves the
relying party through the federation, and the federation master publishes its own list of redirect
URIs for `azuma-demo-ru`. That list contains the two React Native callbacks and nothing of ours, so
every federated provider refuses a callback on `doa-example-app.azuma-health.tech` even though the
broker accepts it. Adding URIs at the broker does not propagate to the federation.

Borrowing a URI the federation already trusts is therefore the only way to reach those providers
before the federation registration is updated. It costs two things worth knowing:

- **The React Native example claims the same App Link.** With both apps installed, only one gets the
  callback, and which one is not defined. Keep one on a test phone.
- **It is not our domain.** The association file that lets this package claim that link lives in the
  `mimoto-examples` repository, so a change there is a change in someone else's project.

`https://doa-example-app.azuma-health.tech/health-id/callback` stays registered on the client and the
page stays published, so moving back is one value in `config.json` and the two Gradle properties -
worth doing the moment the federation carries it.

### Account transfer (variant A)

Sign in once at the app the user is leaving, and azuma creates an account for that identity and binds
it to this phone: screen 1 gains a third action, A1 explains what moves and takes consent, the
hand-off runs in the system browser, A2 confirms the identity that came back, and the record keeps
`transferredFrom` and the date. The journey is
[`lib/src/customer/journeys/transfer.dart`](lib/src/customer/journeys/transfer.dart); the hand-off is
[`lib/src/core/transfer_provider.dart`](lib/src/core/transfer_provider.dart). Specified as variant A
in [`docs/spec/variants.md`](docs/spec/variants.md).

**It is hidden until `TRANSFER_*` is configured, and it can only be pointed at Google or Apple.** DOA
validates tokens on `account/register/{google,apple}` and nothing else; a previous provider that is
neither needs generic per-tenant OIDC providers in DOA (with `registrationOnly` and
`AllowAddingNewDeviceOnlyOnRegistration`), which is a backend feature that does not exist. So the app
side is complete and the general case is still blocked.

To run it against Google, three things have to exist, none of them in this repository:

1. An OAuth client for this app whose redirect URI is `TRANSFER_REDIRECT_URI`
   (`https://doa-example-app.azuma-health.tech/callback/transfer` by default).
2. That client id in the tenant's `GoogleOidcData.ValidAudiences`, with `GoogleTeRegistrationEnabled`
   and `GoogleTeLoginEnabled` on.
3. The redirect claimed by the app on both platforms: Android through `transferCallbackHost` /
   `transferCallbackPath` (the manifest's second app-link filter), iOS through the associated domain -
   `doa-example-app.azuma-health.tech` already publishes `/callback/*` in its
   `apple-app-site-association`, so iOS needs nothing new.

Until those exist the flow has never run against a live provider; what is tested is what the app does
with an identity once it has one (`test/transfer_flow_test.dart`).

**A correction to the list above.** Google will not issue an OAuth client that combines an https
redirect with no client secret: its public clients (Android/iOS/desktop) use custom-scheme or loopback
redirects, and https redirects belong to web clients, which need a secret at the token endpoint - a
thing an app must never carry. Apple wants a signed client-secret JWT. So the browser hand-off as
built cannot be configured against either of the two providers DOA validates. The generic providers
that do support public clients with https redirects are exactly the ones DOA does not accept yet.
Today the journey can therefore run end to end only with Health-ID standing in as the previous
provider, or as the demo below.

**Demo mode.** `"TRANSFER_DEMO": true` in `config.json`, in a **debuggable build only** (a release
build folds the path away whatever the define says), shows the transfer screens with no provider at
all: "Continue to …" opens an in-app sheet that accepts anything typed, A2 shows what was typed, and
"Create my account (demo)" ends the demo with a notice instead of contacting DOA. Nothing is minted -
DOA validates provider tokens against the provider's own keys and would refuse it - and nothing is
written, because there is no account behind it. Every demo screen says it is one.

After a transfer the account needs a DOA-native way in before the provider is retired - the e-mail the
provider supplied, or a passkey added on the account screen. The spec leaves open whether leaving
screen 8 should be blocked until one exists; this build does not block it.

### The phone-key profile (variant C)

The lightest account DOA supports: a username and a password once, and from then on this phone signs
the user in. `auth/login/id` takes the account id and is authenticated by the bound device key alone -
no password, no identity token, nothing to phish.

**What makes it honest is the key, not the UI.** In this profile the *device key itself* is created
with user authentication required, strong biometrics only, invalidated when enrolment changes, and
valid for 600 seconds after one authentication - one prompt per ten-minute session. Signing does not
ask the app's permission: the keystore throws `UserNotAuthenticatedException`, the channel raises the
prompt, and only then does the signature happen
([`DeviceBindingChannel.kt`](android/app/src/main/kotlin/com/doa/example/devicebinding/flutter/DeviceBindingChannel.kt)).
A boolean "biometric check" in front of an ungated key would be a promise the app could skip; this is
the secure hardware's condition.

**One thing the hardware does not promise.** A time-bound key counts *any* strong-biometric
authentication inside its window - unlocking the phone with a finger included. Left to the keystore
alone, a sign-in a minute after unlocking the phone asks nothing, which is exactly what the first
device test showed. So the journey runs the prompt itself at every session start
(`DeviceBinding.unlock`, the `unlock` channel method), and only then signs. The two layers say
different things and both are true: the prompt is what the session promises, and the keystore is what
refuses a signature without a biometric in the window - the app cannot skip the second even if it
forgot the first.

| | |
|---|---|
| Registration | `account/register/username` - no biometric asked: creating a gated key needs no authentication and the request is unsigned. The first prompt is C2's "Unlock", the first sign-in |
| Every login | `challenge/login` -> the fingerprint prompt, run by the journey every session -> `auth/login/id`, signed by the gated key, device-bound, with integrity data |
| Another phone | username and password once on the new phone (`device/register/username`), or a passkey added on the account screen |
| Screens | C1, C2, a lighter account screen and an unlock screen ([`phone_key_views.dart`](lib/src/customer/views/phone_key_views.dart)) |
| Record | `username` instead of an e-mail; no separate biometric key, because there is no second key |

Run it with `--dart-define=PROFILE=phone-key`, or pick **Phone key** on the launcher.

**Android only.** The iOS device key is an App Attest key, which cannot be biometric-gated; the Secure
Enclave key the spec suggests instead is not what DOA validates on iOS. So the flow refuses on iOS and
says why, rather than gating in software and calling it hardware-enforced. Making it real there is a
backend question: DOA would have to accept a Secure Enclave signature as the device proof.

**What the server sees is one factor.** That the key is biometric-gated is written into its attestation
chain, which DOA does not read yet. Until it does, this profile is for tenants outside the
DiGA scope or willing to run at a lower assurance level with O.Auth_4 consent, which is what
[`docs/spec/variants.md`](docs/spec/variants.md) records. The conformance checklist's
O.Auth_4 row records that consent; beyond it the variants have not been assessed - worth doing before
any of them is offered to real users.

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
| `PasskeysOptions.Domain` | the RP domain hosting `assetlinks.json`: `doa-example-app.azuma-health.tech` (source: `examples/.domain/doa-example-app/`), `mimoto-example-app.azuma-health.tech` until then | passkeys |
| `GoogleDeviceAttestationOptions.AllowedSecurityLevels` | drop `Software` | attestation to mean anything - the software root's private key is public in AOSP |
| `GoogleDeviceIntegrityData.PackageName` | `com.doa.example.devicebinding.flutter` | Play Integrity enforcement |
| `GoogleDeviceIntegrityServiceAccount` | service-account JSON with Play Integrity API access to the Cloud project | Play Integrity enforcement |
| `GoogleDeviceAttestationOptions.ValidateIntegrity` | `true` | Play Integrity on registration and new devices |
| `AuthOptions.EmailValidateIntegrityOnLogin`, `HealthValidateIntegrityOnLogin`, `PasskeysValidateIntegrityOnLogin`, `BiometricsValidateIntegrityOnLogin` | `true` | Play Integrity on logins |
| `GoogleDeviceIntegrityOptions.ValidateDeviceIntegrity`, `ValidateAppIntegrity` | `true` (defaults) | `ValidateAppIntegrity` requires `PLAY_RECOGNIZED`, so only Play-delivered builds pass |

Every Play Integrity enforcement switch defaults to off; the app sends tokens either way. A tenant holds
one package name, so it cannot verify this app and the React Native example at the same time.

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
[variants](docs/spec/variants.md) (variants are listed, not implemented). Each flow has its
own device record, so they behave like separate installs. `--dart-define=PROFILE=customer` removes
the launcher and opens on screen 1; that is the binary to review.

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
fail-closed paths. They do not prove attestation, integrity verdicts, authenticator interoperability or
conformance - those need a phone, a configured tenant and the release build. The conformance
checklist marks which rows still wait for that.

## Troubleshooting

| Symptom | Cause | Fix |
|---|---|---|
| Registration fails with an attestation error on an emulator | Emulators produce a software attestation; pie rejects it | Use a physical device, or a tenant whose `AllowedSecurityLevels` includes `Software` for local development only |
| `RegistrationNotPossible` | Email registration disabled on the tenant | Enable it, or add this device to an existing account via passkey / Health-ID |
| "The device check with Google Play could not be completed" | Play services missing/outdated, offline, or the Cloud project not linked | Update Play services; link the project in the Play Console; check `PLAY_INTEGRITY_CLOUD_PROJECT_NUMBER` |
| "Google Play could not confirm that this device and app are unmodified" | The tenant enforces integrity and the verdict failed - rooted/unlocked device, sideloaded build with `ValidateAppIntegrity`, or a stale token | Expected on a modified device. For sideloaded test builds, turn off `ValidateAppIntegrity` on the test tenant |
| "This app requires strong biometrics" | No fingerprint / strong face enrolled, or the device has only weak biometrics | Enrol one in device settings |
| Passkey creation fails only on testers' phones, or on yours after a re-install; logcat shows `RP ID cannot be validated`; the app says "Passkeys aren't available in this build" | The build is signed by a certificate not listed for **this package name** in the RP's `assetlinks.json`. The tenant's RP is `mimoto-example-app.azuma-health.tech`, whose file lives in `mimoto-examples/.domain/mimoto-example-app/.well-known/` and deploys on push to `main` | Add an entry for `com.doa.example.devicebinding.flutter` with the certificate's SHA-256 (debug key: `keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android`), both relations - see [Passkeys and the signing certificate](#2-passkeys-and-the-signing-certificate) |
| Health-ID callback opens in the browser, app never returns | App Links verification failed: `assetlinks.json` missing on the callback domain, or host/path do not match `HEALTH_ID_REDIRECT_URI` | Publish the association; make the Gradle properties match the redirect URI exactly |
| `MissingPluginException` on a `com.doa.example...` channel | Dart and Kotlin channel names drifted, or the app is hosted without `MainActivity` | The names are plain strings on both sides - grep for the channel constant |
| "Secure storage could not be read. Retry before continuing." | The RSA-4096 wrapping key is gone (keystore reset, restore to other hardware) or the store file is corrupt | Deliberate: the app never treats this as a fresh install. Reinstall to start over |
| First write after install is slow | The TEE generates the RSA-4096 wrapping key on first launch | Expected once; measured in seconds on some devices |
| Release `appbundle` on Windows: "failed to strip debug symbols" | Known Flutter/NDK issue | The `.aab` is still produced and valid; check the file, not the exit message |
| Release build behaves differently from debug | R8 renamed something loaded reflectively | `android/app/proguard-rules.pro` keeps Tink and `androidx.credentials`; add a keep if you introduce another reflective library |

## Releasing to testers via Google Play

None of this is app code, and the item most likely to bite (§2) is not where you would look for it.

### 0. Which track

| | Internal app sharing | Internal testing track | Open testing |
|---|---|---|---|
| Where | Play Console -> top-right menu -> *Internal app sharing* | *Testing -> Internal testing* | *Testing -> Open testing* |
| Audience | anyone with the link, from an allowlisted email | up to 100 testers, by email list | anyone on Play; the listing is public |
| Review / forms | none | app content forms required | app content forms **and** Google review per release |
| `versionCode` | reuse freely | must increase on every upload | must increase on every upload |
| Signed with | a **separate internal-app-sharing key** | the **Play app signing key** | the **Play app signing key** |

Create the app once with package name `com.doa.example.devicebinding.flutter`; it is permanent after the
first upload.

### 1. An upload key

```bash
cd examples/flutter-device-binding/android
keytool -genkey -v -keystore upload-keystore.jks -storetype JKS \
  -keyalg RSA -keysize 2048 -validity 10000 -alias upload
cp key.properties.example key.properties     # fill in the passwords
flutter build appbundle --release --dart-define-from-file=config.json
```

`android/.gitignore` excludes `key.properties`, `*.jks` and `*.keystore`. Losing the key is recoverable
through Google; losing the passwords is not.

### 2. Passkeys and the signing certificate

DOA does not pin the WebAuthn origin (it takes it from the client's own assertion - a finding tracked
on the backend). **Android enforces it instead, before any request leaves the
phone**: Credential Manager only creates or uses a passkey for an RP domain whose
`https://<rp-domain>/.well-known/assetlinks.json` lists this package name together with the SHA-256 of
the certificate the installed build was signed with.

Google re-signs whatever you upload, and *which* key depends on the path, so there are three
certificates and every path you use needs its fingerprint listed:

| Build reaches the device via | Signed with | SHA-256 from |
|---|---|---|
| `flutter build apk` / `adb install` | your upload or debug key | `keytool -list -v -keystore android/upload-keystore.jks -alias upload` (debug: `~/.android/debug.keystore`, alias `androiddebugkey`, password `android`) |
| Internal testing, **open testing**, production | the Play app signing key | Play Console -> Release -> Setup -> App integrity |
| Internal **app sharing** | a separate internal-app-sharing key | Play Console -> Internal app sharing |

Passkeys work on your desk, keep working once the Play signing key is listed, and still fail for
everyone on an internal-app-sharing link - the third certificate nobody looks up.

The same file, on the Health-ID callback domain, is what makes the OAuth callback open the app.

### 3. What Play asks for

Internal testing only: **App access** (demo credentials - the app is login-only), **Data safety**
(credentials and tokens stay on device and go to DOA; no third parties, no analytics SDKs), a privacy
policy URL, content rating. The manifest asks for `INTERNET` only; `allowBackup` and cleartext are off.

`versionCode` comes from `version:` in `pubspec.yaml` (`1.0.0+1` -> code `1`); bump the `+n` per upload,
or pass `--build-number` from your pipeline.

### 4. Uploading

Build the bundle pinned to the customer profile:

```bash
flutter build appbundle --release --dart-define=PROFILE=customer --dart-define-from-file=config.json   --obfuscate --split-debug-info=build/symbols
```

An **app bundle** is the only format Play accepts for new apps; Play generates the per-device APKs. The
app must exist in Play Console with one release uploaded by hand before a pipeline can upload through
the Publishing API, which cannot create an app. Keep the R8 `mapping.txt` and `build/symbols/` of every
upload, or crash reports stay unreadable.

Two things to know. **Open testing is public**: the listing is discoverable on Play and anyone can join,
which is a lot of exposure for a sample wired to a development backend; `internal` keeps it to an
invited list. And **every open-testing release goes through Google review**, so uploads produce a queue
of reviews rather than instant builds.

## Releasing to testers via TestFlight

```bash
flutter build ios --release --config-only --dart-define=PROFILE=customer --dart-define-from-file=config.json   --obfuscate --split-debug-info=build/symbols
```

then `xcodebuild archive` and an App Store export with `ios/ExportOptions.plist`. Signing is automatic
through an App Store Connect API key, so no certificate or profile lives in the repository. The build
number must rise on every upload; the version comes from `pubspec.yaml`.

One-time setup: the App ID `com.doa.example.devicebinding.flutter` with **App Attest** and
**Associated Domains**, an App Store Connect record for it, and an API key with the App Manager role.

Before the first upload:

- **Export compliance.** `Info.plist` declares `ITSAppUsesNonExemptEncryption` as `false`, as the Swift
  example does: the app ships no cryptography of its own and uses only TLS and the platform's -
  App Attest, the Secure Enclave, the keychain - which is exempt. Without the declaration every build
  waits in App Store Connect for the encryption question. Confirm the claim still holds if the app
  ever carries its own cryptography.
- **App Attest environment.** `Runner.entitlements` says `development`. Apple documents that TestFlight
  and App Store builds use the production environment regardless; should the export reject the value,
  Release needs its own entitlements file with `production`. The tenant accepts both environments by
  default (`AppleDeviceAttestationOptions.AllowedEnvironements`).
- **Associated domains.** Passkeys and the Health-ID return need this bundle in the
  `apple-app-site-association` of both domains in `Runner.entitlements`. doa-example-app's file
  lists it already; mimoto-example-app is published from the mimoto-examples
  repository and needs `webcredentials` plus `applinks` for `/rn-ce/code/ce`.

Testers in an internal group see a build once it finishes processing. External testers see it only
once it is added to their group, and the first build of each version goes through Beta App Review.

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
the app after changing it) and the generated `test/` stubs. A protocol change in `services/organization`
is not done until an example client regenerates cleanly against it.

The customer journey posts raw maps through `DeviceBoundApi`, not the generated request models, so it
tolerates fields the client has not been regenerated for - which is how it already sends the
`keyAttestation` field.

## Layout and status

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
docs/                        architecture, requirements, journeys/ index + one page per journey
test/                        72 tests: customer_flow_test.dart (the journey suite), transfer_flow_test.dart,
                             phone_key_flow_test.dart, navigation_test.dart, widget_test.dart (the screens),
                             customer_api_test.dart, health_id_proof_test.dart
assets/fonts/                Figtree (OFL), the corporate typeface
```

### What a debug build says about itself

The Health-ID journey crosses a browser, the insurer's app and two servers, so a debug build names the
step it is on (`health-id: requesting the token`), the host and path of a callback it received, the
backend's error code when a request is refused, and the fixed title of the notice the user sees. Never
a token, a challenge, a query string or a backend message, any of which can quote what was submitted.

`adb logcat | grep -E "health-id:|outcome:|doa rejected"` is the whole flow in one screen. Release
builds carry none of it - `kDebugMode` is a compile-time constant, and the release check under
[Verifying a change](#verifying-a-change) proves the strings are absent.

### DevTools (debug builds only)

The bug icon in the app bar - present only when `kDebugMode`, so the release build carries neither the
button nor the screen - opens a state inspector (device record, session and seconds remaining, config),
the raw profile with per-credential **Unlink**, **Force-expire session**, **Reset local state**, and a
**runtime override** of base URL and application id that is stored in the secure store and applied at
the next start. Release builds keep the compiled `AppConfig` values and cannot be repointed. It offers
no stored password, no refresh token, and no way past the biometric gate.

**Status.** The customer journey is complete for the accepted requirements and verified by tests, analyze
and both APK builds; nothing has run against a configured tenant on a physical device since the Play
Integrity and attestation changes. The original 1:1 Kotlin port, including its README and BSI
dependency audit, is in git history before this example replaced it.
