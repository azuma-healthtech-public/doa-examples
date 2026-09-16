# Sign in on a bound device

An install with a device association shows *Welcome back*. Every login here is a **device-bound
request**: the payload is signed by the device key, and DOA verifies that signature before anything
else. All four fetch a `login` challenge, claimed single-use by the server, and carry
`deviceBoundIntegrityVerificationData: {challenge: <that challenge>, androidIntegrityToken}` inside
the signed payload.

After a session has expired, only [biometrics](biometrics.md) can start the next one. The other three
methods are for the first sign-in after registration, and after "Repair biometric setup".

| Method | Call | Extra |
|---|---|---|
| Email - `loginEmail` | `POST auth/login/email` `{email, password, scope: '', requestChallenge, deviceBoundIntegrityVerificationData}` | email is the persisted one; only offered when the association has an email |
| Passkey - `loginPasskey` | `POST auth/login/passkeys/generate-options` `{identifier?}` -> `getCredential` -> `POST auth/login/passkeys/verify` `{identifier?, assertion, scope, requestChallenge, deviceBoundIntegrityVerificationData}` | `identifier` is the account id when known |
| Health-ID - `loginHealthId()` | [broker flow](health-id.md) -> `POST auth/login/healthId` `{identityToken, scope, requestChallenge, deviceBoundIntegrityVerificationData}` | |
| Biometrics - `loginBiometrics` | see [biometrics.md](biometrics.md) | the only method after expiry |

## Completing a login - `_complete`

The response token's `sub` must equal the persisted account id (otherwise *This device belongs to a
different account*); the deadline becomes the earliest of now + 10 min, `exp` and `expiresIn`; a
`refreshToken`, if present, is discarded; `postLoginActions` are recorded and gate entry
(`PasswordChangeRequired` -> password screen; anything else except `DeviceBindingNearingExpiration` ->
maintenance message).

## Errors

| Response | App |
|---|---|
| 401 | session dropped, *Authentication was not accepted. Please sign in again.* |
| `DeviceBindingInvalidIntegrity` / `AuthLoginIntegrityDataMissing` | O.Resi_2 risk message |
| anything else | generic retry message; backend text is never shown |

## Tests

*fixed deadline locks; cancelled login stays locked; biometrics renews*, *expiry during signing prevents
sending a protected request*, *device-bound logins carry integrity data over the signed login
challenge*, *a rejected integrity verdict explains the risk and grants no session*; and in
`customer_api_test.dart`, *device envelope transports the exact signed bytes and expected URL* and
*authorization is rechecked after asynchronous signing before network*.
