# Journey variants

Three further example journeys, each a **variant profile** of [customer-app.md](customer-app.md): it
inherits every principle and policy there unless a row below says otherwise, and only the delta is
written down. Screen numbers refer to the design canvas; new screens are lettered per variant.

| | A · Account transfer | B · OIDC + biometrics | C · Username, login by id, local biometrics |
|---|---|---|---|
| Who it is for | An app moving its existing users off a previous identity provider onto DOA | An app whose users sign up with Google or Apple (or a tenant-approved OIDC provider) | Low-friction accounts: no email, no password after day one, the phone is the credential |
| Identity at registration | The previous IdP's id token | The provider's id token | Username + password (used once, kept for recovery) |
| Sign-in afterwards | DOA-native: email / passkey / Health-ID / biometrics | Biometrics primary; the provider as alternative | `login/id`: the bound device key alone, gated by biometrics on the phone |
| Factors the server verifies | Two, as in the customer app | Two | **One** (possession) unless DOA reads the device key's auth tags - see C |
| Second phone | Passkey / Health-ID (the previous IdP is going away) | Provider, if the tenant allows; else passkey | Username + password via `device/register/username` |
| BSI TR-03161-1 | Conformant as the customer app once transferred; transfer step needs consent | O.Auth_4: lower assurance, offered only with informed consent and a tenant decision | O.Auth_3 not met by the server today; a profile for non-DiGA or low-risk tenants |
| DOA gap | **Generic OIDC provider support** - today only Google and Apple | None for Google/Apple; generic providers as in A | None |

## A. Account transfer from a previous identity provider

**Purpose.** Users of an existing app already have an identity at some provider (the app's own IdP,
a partner, a corporate directory). They sign in there once, and a DOA account is created for that
identity, bound to this phone. From then on they are DOA users; the previous provider is retired.

**Status in the Flutter example.** Built: screen 1's third action, A1 with consent, the hand-off, A2,
the registration, the `transferredFrom` record and a later sign-in through the provider
(`lib/src/core/transfer_provider.dart`, `lib/src/customer/journeys/transfer.dart`). The flow stays
hidden until `TRANSFER_*` is configured, because it can only be pointed at a provider **DOA already
validates - Google or Apple** (`TRANSFER_DOA_PROVIDER` picks the route). The generic case below is
still blocked on the backend, so a previous provider that is neither cannot be configured, however
complete the app side is. Not yet exercised against a live provider - and, as it turns out, it cannot
be against Google or Apple as built: neither issues a public client with an https redirect and no
secret, so the browser hand-off with PKCE only fits providers DOA does not validate yet. End to end it
runs today only with Health-ID standing in as the previous provider.

**Demo mode** (`TRANSFER_DEMO`, debuggable builds only) shows screen 1's action, A1, the hand-off and A2
with no provider: an in-app sheet stands in for the sign-in and accepts anything, and the journey ends
before DOA with a notice, since no token minted in the app could pass DOA's validation and a record
without an account would only break the next sign-in. Every demo screen says so.

**What DOA has today.** OIDC registration and login exist for **Google and Apple only**:
`account/register/google|apple`, `auth/login/google|apple`, validated against the tenant's
`GoogleOidcData` / `AppleOidcData` (`ValidAudiences`, `AllowAddingNewDeviceOnlyOnRegistration`).
A previous IdP that is neither needs DOA to accept **generic OIDC providers per tenant**: issuer,
discovery or JWKS URL, valid audiences, allowed algorithms, and two flags this journey relies on -
`registrationOnly` (the provider may create accounts during a transfer window but never sign in)
and `AllowAddingNewDeviceOnlyOnRegistration`. That is a DOA feature ticket; this journey is blocked
until it exists.

**Screens.**

| # | Screen | Delta |
|---|---|---|
| 1 | Welcome | Adds a third action under the two buttons: "Already using [previous app]? Transfer your account" |
| A1 | Transfer intro | What moves (your identity and, if the provider supplies it, your verified email), what does not (any data held by the previous app unless the tenant migrates it separately), what happens next (sign in there once, then set up biometrics here). Consent checkbox for DOA processing, unchecked. Primary: "Continue to [provider]". Secondary "Not now", and back: both return to the root - the transfer is entered from its own tile, so leaving it goes back to where that tile is |
| O6 | External hand-off | As designed; provider name and logo. Cancelling the hand-off cancels the transfer and returns to the root |
| A2 | Confirm transfer | The identity that came back, masked (e-mail or display name), the sentence "This creates your azuma account for this identity on this phone", primary "Create my account", secondary "This isn't me" (aborts, nothing created, returns to the root). Back returns to A1 |
| 6 | Enable biometrics | Unchanged, mandatory |
| 8 | Account & security | Adds a line "Transferred from [provider] on [date]"; the second-phone banner now reads that the previous sign-in will stop working and the user should add a passkey or Health-ID |

**Sequence.** Standard OIDC authorization-code flow with PKCE against the previous provider, done as
in 4.6 of the customer app (verifier, state and nonce from the CSPRNG; system browser; app-link
callback matched exactly; token endpoint; `nonce` checked) -> `challenge/registration` -> device proof
-> `account/register/<provider>` `{identityToken, requestChallenge, language, deviceAttestation,
androidIntegrityToken}` -> account id. Then a session is needed for biometric setup: preferred, the
backend ticket lets OIDC registration return a token like passkey registration does; otherwise
`auth/login/<provider>` with a fresh id token (a second hand-off - decide in the ticket whether DOA
may accept the same id token twice within its lifetime; today it is not specified).

**Policy delta.**

- The previous provider is a registration-time identity only. After transfer, the account must have
  a DOA-native way in besides biometrics before the first session ends: either the provider supplied
  a verified email (then the email path works after a password is set through the forgot-password
  flow) or the user adds a passkey on screen 8. Until one exists, screen 8 shows a persistent banner;
  whether to *block* leaving the screen is an open product question.
- `AllowAddingNewDeviceOnlyOnRegistration = true` for the transfer provider; a transferred identity
  never enrols a second phone through the provider.
- Consent is collected on A1 (before the hand-off, because the hand-off already sends data) and the
  identity token is handled exactly like a Health-ID token: never shown, never logged, handed to DOA
  unverified.
- Tenant: the transfer provider registered with `registrationOnly`; the transfer window is a tenant
  setting, after which the button on screen 1 disappears (read from tenant options, not a build flag).

**BSI.** Once transferred the app is the customer app. The transfer itself needs O.Purp_3 consent and
O.Auth_4 consideration only if the previous provider is of lower assurance than DOA's methods; the
evidence file should record the provider's level.

## B. Registration with OIDC, then biometrics

**Purpose.** Sign up with an identity the user already has. Google and Apple are supported by DOA
today; anything else waits for the generic provider support from A. Biometrics are mandatory after,
and the provider remains an alternative sign-in on the linked phone.

**Status in the Flutter example. Not built - planned for later, and deliberately absent from the
code.** This section stays as the design; nothing in the app implements it, and the launcher no longer
carries a tile for it, because a tile that opens the reference journey under another name promises
something the app does not do.

It was built once and then taken back out to keep the example small: native provider sheets are new
platform code on both sides (Credential Manager on Android, AuthenticationServices on iOS), each
platform can only present the provider it supports natively, and running it needs credentials and
tenant settings that do not exist yet - Google's web client id in `GoogleOidcData.ValidAudiences`, the
bundle id in `AppleOidcData.ValidAudiences`, and `AuthOptions.GoogleTe*`/`AppleTe*`, all of which
default to off. When it returns, the DOA side is already proven by A, which uses the same
`account/register/{google,apple}` and `auth/login/{google,apple}` calls; what has to be written again
is the native sheet, the consent screen B2, and the provider as a standing method on 2c and 8.

**Screens.**

| # | Screen | Delta |
|---|---|---|
| 2a | Create account | Adds "Continue with Google" and "Continue with Apple" under an "Other" section, using the providers' official brand assets and button rules (the canvas shows placeholders) |
| B1 | Provider sheet | **Native** - Sign in with Apple / Google Identity Services on the platform, not a browser hand-off; the app sets the nonce and verifies it in the returned id token |
| B2 | Consent | The identity returned (masked), consent checkbox for DOA processing, primary "Create account" |
| 6 | Enable biometrics | Unchanged |
| 2c | Sign in (linked phone) | Biometrics primary; the provider button as one of the alternatives |
| 8 | Account & security | The provider listed under sign-in methods as "Connected"; no unlink in the customer UI |

**Sequence.** Platform SDK -> id token (nonce verified) -> `challenge/registration` -> device proof ->
`account/register/google|apple` `{identityToken, requestChallenge, language, deviceAttestation,
androidIntegrityToken}` -> account id -> `auth/login/google|apple` `{identityToken, requestChallenge,
scope: ""}` signed by the device key, with a fresh id token from the SDK's silent re-authentication ->
session -> screen 6. Linked-phone login: `challenge/login` -> SDK -> `auth/login/<provider>` with
`deviceBoundIntegrityVerificationData` over the login challenge.

**Second phone.** Only if the tenant's `AllowAddingNewDeviceOnlyOnRegistration` is off for that
provider and DOA offers a `device/register/<provider>` route - confirm in the implementation ticket;
otherwise passkey only, and screen 8 says so.

**Policy delta and BSI.** Google and Apple are lower-assurance identities under TR-03161-1 O.Auth_4:
the tenant decides to offer them, the user consents on B2, and the evidence file records the level.
Apple's private e-mail relay means the account may have no reachable e-mail; Google account recovery
is outside the tenant's control - both belong in the risk assessment. Everything else - device key,
mandatory biometrics, ten-minute sessions, integrity - is unchanged and is what keeps the *session*
at the customer app's level even when the *identity* is not.

**Tenant.** `GoogleOidcData.ValidAudiences` / `AppleOidcData.ValidAudiences` with the client ids of
each platform build; `GoogleTeRegistrationEnabled` / `GoogleTeLoginEnabled` and the Apple pair.

## C. Username, then login by id with the device key, biometrics kept on the phone

**Purpose.** The lightest account DOA supports: a username and a password entered once at
registration, and from then on the phone signs the user in - `auth/login/id` takes the account id
and is authenticated by the bound device key alone ("no password, no external identity token", in
DOA's own words). Biometrics gate that key **on the phone**; the server never sees a biometric
signature.

**Status in the Flutter example.** Built, **Android only**. The device key is generated with user
authentication required, strong biometrics only, invalidated on enrolment change and a 600-second
authentication validity, and the key's own refusal to sign is what raises the prompt: signing catches
`UserNotAuthenticatedException`, prompts, and signs afterwards (`DeviceBindingChannel.kt`). The prompt
carries no `CryptoObject` - that binding is for per-use keys, and a time-bound key rejects it.
Seen on the first device test: Android opens a time-bound key's window on *any* strong-biometric
authentication, unlocking the phone included, so the keystore alone asked for nothing at a session
start shortly after the phone had been unlocked with a finger. The journey therefore runs the prompt
itself at every `login/id`, as the sequence below now says; the gated key remains the enforcement
underneath. Registration asks for no biometric at all - the first prompt is C2's "Unlock". The
journey is `lib/src/customer/journeys/phone_key.dart`: `account/register/username`, then `auth/login/id`
for every session including the first, and `device/register/username` for another phone. Screens C1,
C2 and the lighter account and unlock screens are in `lib/src/customer/views/phone_key_views.dart`.

**iOS refuses this profile**, and says so rather than pretending. Its device key is an App Attest key,
which cannot be biometric-gated; the Secure Enclave key this section suggests is not what DOA
validates on iOS, and a software check in front of an ungated key would be exactly the UI promise
forbidden below. Making it real on iOS means DOA accepting a Secure Enclave signature as the device
proof - a backend question, not an app one.

**Screens.**

| # | Screen | Delta |
|---|---|---|
| 1 | Welcome | Proof lines change: "your phone is your key", "unlock with your fingerprint or face", "no e-mail needed" |
| C1 | Choose a username | Username, password, confirm, consent. Amber banner: the password is only for adding another phone or recovering; there is no e-mail to reset it |
| C2 | Protect this phone | Explains that the app is unlocked with the biometrics enrolled on this phone, that this is enforced by the phone's secure hardware, and that changing enrolment means signing in with username and password again. Primary "Unlock": the first sign-in, and the **first biometric prompt** of the account - registration on C1 asked for none. No skip |
| 8-lite | Account | Username, "This phone is your key", change password, add a passkey to use another phone, sign out |
| 7-lite | Unlock | Same lock screen; the primary action is "Unlock" (biometric prompt), then `login/id` runs silently |

**Sequence.** Registration: `challenge/registration` -> integrity token -> **device key created
biometric-gated** (below) -> attestation -> `account/register/username` `{username, password,
language, requestChallenge, deviceAttestation, androidIntegrityToken}` -> account id (and a
`deviceAttestationKey` if the tenant has `CreateDakOnRegistration`; store it like a password or ignore
it - decide per tenant). **Registration asks for no biometric**: creating a gated key needs no
authentication, only using it does, and `register/username` is not signed by the device key. The first
prompt is C2's "Unlock" - the first sign-in. Every login, including that first one: `challenge/login`
-> **the app runs the biometric prompt** -> `auth/login/id` `{id, scope: "", requestChallenge,
deviceBoundIntegrityVerificationData}` signed by the key -> session. Every ten minutes the same.

**The key that makes it honest.** Do not add a boolean "local biometric check" in front of an
ungated key - that is a UI promise. Instead the **device key itself** is generated with user
authentication required, strong biometrics only, invalidated on enrolment change, and an
authentication validity of 600 seconds (Android `setUserAuthenticationParameters(600,
AUTH_BIOMETRIC_STRONG)`), so the secure hardware refuses to sign without a strong biometric inside
that window. What the window does *not* deliver on its own is a prompt per session: Android opens it on
*any* strong-biometric authentication, unlocking the phone included, so a sign-in shortly after
unlocking the phone would pass silently. The journey therefore runs the prompt itself at every
`login/id` and signs afterwards. The two layers make different promises and both hold: the explicit
prompt is what the session promises, the gated key is what the hardware enforces, and the app cannot
skip the second even if it forgot the first. On iOS the equivalent is a Secure Enclave key with
`biometryCurrentSet` and `LAContext.touchIDAuthenticationAllowableReuseDuration`, whose maximum is five
minutes - two prompts per session, or a five-minute session for this profile on iOS. With that, the
gating is real and hardware-enforced even though it is local.

**What the server can and cannot see.** `login/id` proves possession of the device key. That the key
is biometric-gated is written into its attestation chain (the user-auth tags), which DOA does not read
today - once DOA reads them, a tenant can *require* a biometric-gated device key and this profile
becomes server-verifiable two-factor without any protocol change. Until then, under TR-03161-1
O.Auth_3 the server verifies one factor, and this profile is for tenants outside the DiGA scope or
willing to run it at a lower assurance level with O.Auth_4 consent. Say so in the evidence file.

**Second phone.** Username + password on the new phone: `challenge/additionalDevice` -> device proof
-> `device/register/username` `{username, password, requestChallenge, deviceAttestation,
androidIntegrityToken}` -> token -> C2 on the new phone. A passkey added on screen 8 works too.

**Policy delta.**

- The record stores `username` instead of `email`; no `biometricAlias` (there is no separate key);
  `login/id` is the only login on a linked phone.
- The password is never stored on the phone and is asked for only on C1 and when adding a phone.
- Enrolment change invalidates the device key -> the account must be re-bound: username + password
  on this phone through the second-phone path (the old binding stays orphaned server-side until a
  device-removal journey exists - open, as in the customer app).
- Tenant: `UsernameRegistrationEnabled`, `IdLoginEnabled`, `Id/UsernameValidateIntegrityOnLogin`,
  optionally `CreateDakOnRegistration`; `BiometricsLoginEnabled` is not needed.

## How the variants live in one app: profiles

Apps are platforms; variants are **profiles** inside each app. A profile is a small declarative
object read once at start - which device-key parameters to use, which biometric mode, which entry,
setup and renewal screens, how the record is shaped. Two profiles exist at build time (`customer`,
`phone-key`, because C changes how the device key is generated and that is fixed at registration);
A and B are entries in the method picker driven by tenant options, not profiles. The example
launcher (screen 0 in [customer-app.md](customer-app.md)) offers every flow at runtime; a build that
pins `PROFILE=<name>` has no launcher and opens on that flow's welcome screen. Per stack the pin is
the platform's own mechanism: `--dart-define` (Flutter), `productFlavors` (Kotlin), schemes on an
`xcconfig` (Swift), `react-native-config` at build time (React Native). The gate, the run loop, the
envelope, sessions, storage semantics, integrity, error mapping and the test fakes are shared; a
variant's tests are the customer tests with a different profile injected.

| | Set by | Device key | Biometric step | Renewal | Record |
|---|---|---|---|---|---|
| Customer | default | plain, attested | 6, server-linked key | biometric login | alias, id, email, biometricAlias, flow |
| A · Transfer | tenant options | plain, attested | 6 | biometric login | + transferredFrom, date |
| B · OIDC | tenant options | plain, attested | 6 | biometric login | + provider |
| C · Phone key | **build profile** | biometric-gated, 600 s validity, attested | C2, no second key | unlock -> `login/id` | alias, id, username |

## Open questions across the three

1. Generic OIDC providers in DOA (A, and B beyond Google/Apple): a backend ticket; also whether OIDC
   registration should return a session token so the biometric setup needs no second hand-off.
2. Which of these may enrol a second phone through the identity provider, and whether
   `device/register/<provider>` exists for Google/Apple.
3. Whether the transfer (A) blocks leaving screen 8 until a DOA-native method exists.
4. Whether DOA will read the device key's user-auth tags so that C counts as two-factor.
5. Whether Google/Apple sign-in belongs in a DiGA at all (O.Auth_4) - product decision before B.
