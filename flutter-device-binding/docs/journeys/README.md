# Journeys

One page per journey. Each lists the screens, the exact backend calls in order, what is
persisted, how failures are handled, and which test pins the behaviour. Read
[architecture.md](../architecture.md) first for the state gate, session and storage rules
they all rely on.

| Journey | Entry points |
|---|---|
| [Registration](registration.md) | email + password, passkey, Health-ID |
| [Login](login.md) | email, passkey, Health-ID, biometrics; session completion and post-login actions |
| [Biometrics](biometrics.md) | mandatory setup, 10-minute renewal, invalidation and repair |
| [Second device](second-device.md) | passkey or Health-ID on a fresh installation |
| [Account & security](account.md) | profile, link Health-ID, add passkey, change password, sign out |
| [Health-ID broker flow](health-id.md) | the browser round trip shared by the three Health-ID journeys |
| [Account transfer](transfer.md) | variant A: sign in at a previous provider once; the demo mode that needs no provider |
| [Phone key](phone-key.md) | variant C: username once, then `login/id` behind a biometric-gated device key (Android) |

## Conventions used on these pages

- Endpoints are written as `<area>/<action>`, meaning
  `POST /deviceBinding/<area>/v1/mobile/<applicationId>/<action>`. Challenges are
  `GET /deviceBinding/challenge/v1/mobile/<applicationId>/<kind>` and are written as
  `challenge/<kind>`.
- **Signed** means the request goes through the device-bound envelope: the JSON payload is
  signed by this installation's device key and sent as `{payload, signature, deviceOs}`.
  DOA verifies the signature against the key it stored at registration. Unsigned requests are
  the ones that create that key.
- **Device proof** is the pair every binding sends: `deviceAttestation` (the key's attestation
  chain over the challenge) and `androidIntegrityToken` (a Play Integrity token over the same
  challenge). See [registration.md](registration.md#device-proof).
- Every server challenge is single-use and expires after an hour. The app fetches a fresh one
  per request and never reuses it.
