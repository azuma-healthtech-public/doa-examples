# Add a second device

A fresh install has no association, so *Sign in* leads to screen 2b, which offers only *Passkey* and
*Health-ID* under the note that a passkey or Health-ID can add this phone and email alone cannot.
Email and biometrics are **not** offered: email cannot enrol a device in this app (even though the API
has an additional-device email endpoint), and a biometric key on device A cannot authenticate device B.
Apply the same restriction on the tenant; the UI is not an authorization policy.

Both paths are the registration shape - persist the pending association, integrity token, device key -
but against the `device/register/*` endpoints with an `additionalDevice` challenge, and they return a
token, so the user is signed in and immediately gated to [biometric setup](biometrics.md) on this
device.

| Method | Calls |
|---|---|
| Passkey - `loginPasskey` on a fresh install | `POST device/register/passkeys/generate-options` `{}` -> `getCredential` -> `GET challenge/additionalDevice` -> `POST device/register/passkeys/verify` `{assertion, scope: '', requestChallenge, deviceAttestation, androidIntegrityToken}` |
| Health-ID - `loginHealthId()` on a fresh install | [broker flow](health-id.md) -> `GET challenge/additionalDevice` -> `POST device/register/healthId` `{identityToken, scope: '', requestChallenge, deviceAttestation, androidIntegrityToken}` |

The account id in the returned token becomes this device's `id`; verify it equals device A's, and that
A still works afterwards. Nothing is copied between devices.

An email-only account must link Health-ID or add a passkey on device A first ([account.md](account.md)
says so in the UI). If A is lost with neither, a separate recovery journey is needed; the app never
falls back to email enrolment or silently creates another account.

## Tests

*device B can use passkey, never email enrollment*, *device B Health-ID enrollment requires local
biometrics*; `widget_test.dart`: *new device offers Health-ID/passkey and separate registration*.
