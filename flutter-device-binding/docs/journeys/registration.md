# Registration

Creates an account and binds this installation to it in one step. Three entry points, one
outcome: a stored device record with the account id, and a session (passkey) or an
instruction to sign in (email, Health-ID). Biometric setup follows every path before the
account home is reachable.

Screens: 1 Welcome → 2a *Create account* → method (3 + 4 for email; 3p account name for passkey; the broker for Health-ID) → 6 Enable biometrics. Code: `registerEmail`, `registerPasskey`,
`registerHealthId()` in [`customer_controller.dart`](../../lib/src/customer/customer_controller.dart).

## Preconditions

Checked before anything is created, in this order:

1. Storage loaded and readable. A failed load blocks with *retry*.
2. No device record on this installation. An existing or pending record means *sign in*; the
   app never creates a second account from a bound device.
3. Strong biometrics enrolled (`BiometricManager.canAuthenticate(BIOMETRIC_STRONG)`).
   Without them the user is told to enrol and retry; the account is not created.

## Device proof

All three methods share this sequence once the method-specific input is ready:

| # | Step | Notes |
|---|---|---|
| 1 | `challenge/registration` → `C` | single-use, server-issued |
| 2 | Play Integrity token over `C` | **first**: if Play cannot produce one, stop here; nothing has been created |
| 3 | Generate device key `customer.device.<hex>` with attestation challenge `C` | hardware-backed or the channel throws |
| 4 | Persist `{alias, email?}` | the pending binding; see failures below |
| 5 | Export the attestation chain | `deviceAttestation` |

The request then carries `requestChallenge: C`, `deviceAttestation`, `androidIntegrityToken`.
DOA verifies the chain to Google's roots, the challenge inside it, the security level, and,
if the tenant enforces it, decodes the integrity token and checks its `requestHash` against
`C`.

## Email

| # | Call | Signed | Body | Then |
|---|---|---|---|---|
| 1 | device proof | | | |
| 2 | `account/register/email` | no | `email`, `password`, `language`, `initiateEmailVerification: true`, `requestChallenge`, `deviceAttestation`, `androidIntegrityToken` | persist `id`, `verificationFlow` |

The password is sent once and never stored. The user verifies the email
(`account/verify/email/confirm`, signed, with `verificationFlow` and the code; resend via
`account/verify/email/initiate`) and then signs in; registration does not return a token.

## Passkey

| # | Call | Signed | Body | Then |
|---|---|---|---|---|
| 1 | `account/register/passkeys/generate-options` | no | `identifier` (the account name the user typed) | WebAuthn creation options, opaque JSON |
| 2 | Credential Manager `createCredential` | | | user picks a passkey provider; dismissing it is a clean cancel |
| 3 | device proof | | | |
| 4 | `account/register/passkeys/verify` | no | `identifier`, `passkeyAttestation`, `deviceAttestation`, `androidIntegrityToken`, `requestChallenge`, `loginScope: ""`, `language` | returns `id` **and** a token → session |

Because the verify call returns a token, registering with a passkey also signs in; the next
view is mandatory biometric setup.

## Health-ID

| # | Call | Signed | Body | Then |
|---|---|---|---|---|
| 1 | [broker flow](health-id.md) | | | `id_token` from the configured provider |
| 2 | device proof | | | |
| 3 | `account/register/healthId` | no | `identityToken`, `requestChallenge`, `language`, `deviceAttestation`, `androidIntegrityToken` | persist `id` |

Only an explicit *Create account* choice reaches this call. A Health-ID *sign in* on a fresh
installation never creates an account; it goes through [second device](second-device.md).
Registration returns no token, so the user then signs in with Health-ID to enable biometrics.

## Failures

| Situation | Effect |
|---|---|
| Play Integrity unavailable | stopped before step 3; nothing persisted; message asks to check Play services and retry |
| Passkey sheet dismissed (before the proof) | nothing persisted; retry allowed |
| DOA rejects with 400 / 403 / 409 / 422 (includes `DeviceBindingInvalidIntegrity`) | pending record cleared, key can be regenerated on retry |
| Timeout or 5xx | pending record **kept**: the server may have accepted the key. Retry reuses it; the key is never overwritten |
| Secure storage write fails | the flow aborts and the storage gate takes over |

## Tests

`customer_flow_test.dart`: *email registration persists verification and never saves
password*, *passkey registration and Health-ID linking preserve account identity*, *cancelled
passkey creation permits retry*, *ambiguous registration keeps the submitted key and refuses to
overwrite it*, *unreadable storage and unavailable biometrics block registration*, *every
registration carries a Play Integrity token over its attestation challenge*, *unavailable Play
Integrity stops registration before a key or binding exists*, *an integrity-rejected
registration leaves nothing pending*.
