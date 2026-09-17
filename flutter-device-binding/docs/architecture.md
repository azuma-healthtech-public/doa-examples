# Architecture

## Layers

```
customer journey   lib/src/customer/        policy + UI: state gate, session rules, what is persisted,
                                            one `part` per journey, one view per state, DevTools (debug)
                   ===============================================================================
core (reusable)    lib/src/core/            one thin Dart class per native channel + the signed envelope
                   android/.../*Channel.kt  the platform APIs the contract needs: KeyStore, BiometricPrompt,
                                            Credential Manager, Play Integrity, secure store, browser hand-off
```

The journey layer knows the customer policy and which endpoints make up a journey. The core knows
the DOA wire contract and the platform, and nothing about accounts or sessions; each channel does one
platform thing and returns bytes or strings. `lib/src/core/README.md` states the rules the core keeps.
Nothing in `customer/` reaches a channel except through a core class.

## Native channels, and why they are custom

Everything below is a direct call to a platform API, kept as thin as the contract allows. pub.dev
alternatives were evaluated and each fails one requirement, recorded in the last column:

| Channel | Does | Why not a library |
|---|---|---|
| `DeviceBindingChannel` | EC P-256 key with `setAttestationChallenge`, exports the chain, signs payloads with `SHA256withECDSA`; for the phone-key profile the key is generated biometric-gated (600 s validity) and `unlock` runs the prompt on its own | No package exposes the attestation chain |
| `BiometricBindingChannel` | EC P-256 (or RSA-3072) key, `BIOMETRIC_STRONG`, per-use auth, invalidated on enrolment change, **with** attestation challenge; `BiometricPrompt` holding a `CryptoObject` so prompt and sign are one call; rejects software-backed keys | `biometric_signature` does all of it except the attestation chain, which DOA does not read yet |
| `PasskeyChannel` | Credential Manager create / get, JSON in and out **unparsed** | `passkeys` re-serialises typed objects; the RP must verify the exact bytes it issued |
| `IntegrityChannel` | Play Integrity standard request, provider cached per Cloud project | Wrappers are unverified and tiny; ~100 lines here |
| `SecureStoreChannel` | Each write sealed with a fresh AES-256-GCM key, wrapped by a decrypt-only RSA-4096 AndroidKeyStore key in the TEE; slot bound as associated data; atomic files in `noBackupFilesDir`; unreadable data is **reported, never deleted** | `flutter_secure_storage` wraps with RSA-2048, fixed; below TR-02102-1's 3000-bit floor |
| `HealthIdChannel` | PKCE verifier/challenge, state and nonce from `SecureRandom`; opens the authenticator URL; hands the app-link callback back to Dart; also the hand-off of the account transfer | Could move to Dart (`Random.secure` + `crypto`) and `flutter_web_auth_2`; kept native so all randomness has one source |
| `CertificateChainEncoding` | base64(comma-joined base64 DER certs) - the one encoding DOA parses for any attestation chain | - |

Every channel call is bounded by a timeout; the two interactive ones (biometric prompt, credential sheet)
bind their result to the Activity lifecycle so an abandoned call errors instead of hanging the UI.

## The customer journey

- **`CustomerController`** - one `ChangeNotifier` holding device state, session and the current message,
  plus the rules every journey shares: `run()` serialises every action and maps errors to user-facing
  text (never echoing backend messages, which may contain submitted credentials); `_deviceProof`,
  `_account` and `_complete` are the device binding, the signed account request and login completion.
  Each journey is a `part` of this library (`journeys/registration.dart`, `login.dart`,
  `biometrics.dart`, `second_device.dart`, `account.dart`, `transfer.dart`, `phone_key.dart`) - an extension that can use those private
  members without them becoming public API. Read a journey file on its own; it is the same code the
  matching `docs/journeys/` page describes.
- **`CustomerScreen`** - the state gate and the lifecycle owner. Order of the gate: storage unreadable ->
  session ended (the dark lock screen, 7) -> no session -> email unverified -> no biometric key ->
  blocking post-login action -> password change required -> account; each state is a function in
  `views/`, using the handful of components in `widgets/`. Within "no session" the screen keeps an
  entry step (welcome, create account, sign in, email registration, email sign-in, the transfer's A1 and A2, the password-changed confirmation, the safety page); the device record
  decides which steps are reachable (`normaliseStep`) and the back button moves between them
  (`PopScope`). Nothing routes around it. The outcome of an action is a `Notice` (tone, optional title,
  body, retry); the view places it as a banner where the design says (top of the content, or above the
  primary action on hero screens), validation lives in the views as field errors, snack-tone notices
  become a four-second snackbar, and an integrity failure is the full-screen S2 state - see
  specification section 3.5. `FLAG_SECURE` is
  set; the body is replaced by a lock icon when the app is not in the foreground; the screen owns the
  text fields so passwords are cleared on background and after every action regardless of view.
- **`DeviceBoundApi`** (core) - the device-bound envelope. A signed request is `{payload: <json string>,
  signature: sign(payload), deviceOs}`; the string that is signed is the string that is sent. An
  `authorize` callback re-checks the session **after** the asynchronous signing and before the network,
  so an expiry during a biometric prompt never sends a protected request. It takes a `RuntimeConfig`;
  release builds only ever see the compiled one.
- **`CustomerSession`** - token, account id, deadline, `postLoginActions`. Valid while both the wall
  clock is before the deadline **and** a monotonic stopwatch is under 10 minutes, so clock rollback does
  not extend a session. The deadline is the earliest of now + 10 min, the token's `exp`, and `expiresIn`.
- **`CustomerStorage`** - one JSON record per flow, `customerDevice.v1.<slot>` (the customer flow also reads the earlier, unslotted key `customerDevice.v1`): `alias`, `id`, `email`,
  `biometricAlias`, `verificationFlow`. Identifiers only. Writes are serialised so a timed-out write
  cannot race a retry.
- **`HealthId`** - the broker flow; see [journeys/health-id.md](journeys/health-id.md).

## Session policy

No `offline_access` is requested; a `refreshToken` in any response is discarded; no refresh endpoint is
called. The access token lives in memory only. Expiry is checked before every protected request, after
asynchronous signing, on every response, on app resume and by a one-second foreground timer. At expiry
the session and profile are dropped and the entry screen offers only biometrics ("Sign in with
biometrics"), "Repair biometric setup" and "Sign out". Restarting the process always requires a login.
Sign-out calls `auth/logout` and clears local state even if that call fails.

Known gap (O.Auth_15 in the conformance checklist): the backend is told only on explicit sign-out; sessions the
app ends itself (expiry, after enabling biometrics, after a password change) are dropped locally only.

## Device integrity

Every registration and second-device enrolment sends `androidIntegrityToken` - a Play Integrity token
whose request hash is the request's own `requestChallenge`, the same challenge the device-key
attestation carries. Every device-bound login sends `deviceBoundIntegrityVerificationData` with the
login challenge and a token over it, inside the signed payload.

Ordering: for registrations the token comes first, so a device Play cannot vouch for never generates a
key or persists a pending binding. For biometric login it comes **after** the prompt, so it is
milliseconds old when the request leaves (a prompt can stay open for minutes; DOA is to bound the age).

The device cannot read the verdict; DOA decodes it with the tenant's service account. A rejection
(`DeviceBindingInvalidIntegrity`) shows the O.Resi_2 risk message and grants no session; a rejected
registration leaves nothing pending.

## Keys and attestation

| Key | Created | Attested over | Sent as |
|---|---|---|---|
| Device key `customer.device.<random>` | first registration or second-device enrolment | the `registration` / `additionalDevice` challenge | `deviceAttestation.attestation` (chain) |
| Biometric key `customer.biometric.<random>` | "Enable biometrics" | the `linking` challenge | `publicKey` + `keyAttestation.attestation` (chain, read by DOA once it reads attestation) |
| Storage wrapping key `customer.storage.wrap.rsa4096` | first launch, in the background | - | never leaves the device |

Aliases are random so an existing customer key is never overwritten: both channels refuse to replace a
`customer.` alias. A rejected registration (400/403/409/422) clears the pending association so a new
key can be tried; an ambiguous failure (timeout, 5xx) keeps it, because DOA may have accepted the
attestation and lost the response.

## DevTools, and what is deliberately not here

`customer/devtools/` exists only in debug builds: the app-bar button and `DevConfig.load()` in `main()`
sit behind `kDebugMode`, a compile-time constant, so the release build contains none of it (verified by
searching the release APK for its strings). It offers a state inspector, the raw profile with
per-credential unlink (`unlinkPasskey`, `unlinkBiometric`, `unlinkHealthId` - account operations the
customer UI does not surface), force-expire, a local reset, and a runtime override of base URL and
application id persisted in the secure store and read once at the next start.

Not here, in any build: refresh tokens, stored passwords, or any path past the biometric gate.
Username registration and `login/id` exist only in the phone-key profile, behind a biometric-gated
device key. The original 1:1 Kotlin port had refresh tokens and stored passwords, and is gone from
this tree.
