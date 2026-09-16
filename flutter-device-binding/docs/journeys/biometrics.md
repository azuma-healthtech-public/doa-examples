# Biometrics: mandatory setup and the 10-minute renewal

Biometrics are not optional. After registration by any method, and after adding this device to an
existing account, the gate shows *Enable biometrics* and nothing else until it succeeds. After every
session expiry, biometrics are the only way back in.

## Setup - `enableBiometrics`

Requires a live session (the account is authenticated first) and `canAuthenticate(BIOMETRIC_STRONG)`.

| Step | Call |
|---|---|
| 1 | `GET challenge/linking` |
| 2 | generate biometric key `customer.biometric.<random>`, EC P-256, per-use auth, `BIOMETRIC_STRONG`, invalidated on enrolment change, **attestation challenge = the linking challenge**; refuse if not hardware-enforced |
| 3 | `BiometricPrompt` with the `Signature` as `CryptoObject` -> signature over the challenge |
| 4 | `POST account/link/biometrics` `{publicKey, keyAttestation: {attestation, deviceOs, deviceName}, requestChallenge, requestSignature, id, accessToken}` - signed by the **device** key |
| 5 | persist `biometricAlias` |
| 6 | drop the session and perform a real biometric login (below) - the link is proven through the backend before entry |

Cancelling the prompt leaves setup pending and the association unchanged; the button is live again.
`keyAttestation` is ignored by DOA until it reads attestation chains, and verified after that; the field is sent now so the
client needs no change then.

## Renewal - `loginBiometrics`

| Step | Call |
|---|---|
| 1 | `GET challenge/login` |
| 2 | `BiometricPrompt` -> signature over the challenge with the biometric key |
| 3 | Play Integrity token over the same challenge - **after** the prompt, so its age is milliseconds |
| 4 | `POST auth/login/biometrics` `{id, requestChallenge, requestSignature, scope: '', deviceBoundIntegrityVerificationData}` - signed by the device key |

Two hardware-bound signatures reach the server: the device key over the payload, the biometric key
over the challenge. Local prompt success alone is never a login.

## When the key stops working

Enrolment changes invalidate the key (O.Auth_5). The prompt then fails; screen 2c offers *Repair
biometric setup* and the lock screen (7) *Biometrics not working? Sign in another way*, which clears the local `biometricAlias` and grants nothing: the user must sign in
with email / passkey / Health-ID and complete setup again. Repair never bypasses biometric renewal.

## Sessions

Fixed 10 minutes from a successful backend login, or the token's `exp` if earlier, checked against a
monotonic clock as well as wall time. Activity, foregrounding and local prompt success do not extend it.
At expiry the profile and token are dropped; a failed, cancelled or offline biometric login leaves the
app locked with retry and sign-out.

## Tests

*mandatory setup, cancellation, backend biometric login and no persisted secrets*, *fixed deadline
locks; cancelled login stays locked; biometrics renews*, *restart retains associations but no
authenticated session*, *early token expiry and monotonic cap survive wall-clock rollback*, *biometric
login requests its integrity token after the prompt, and stops without one*, *biometric link sends the
key attestation over the linking challenge*; `widget_test.dart`: *mandatory biometrics and expired
session hide account controls*.
