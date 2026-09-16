# Account & security

Shown only when `canEnter`: a valid session, email verified, biometrics enabled, no blocking post-login
action. Every call here goes through `_account`, which re-checks the session before signing, again
after the asynchronous signature and before the network, and once more on the response; adds `id` and
`accessToken` to the payload; and is signed by the device key.

| Action | Call | Notes |
|---|---|---|
| Load / reload settings - `loadProfile` | `POST account/userInfo` `{}` | shows linked methods and passkey count; a failed load is an unknown state with *Reload*, never "no credentials" |
| Add Health-ID - `linkHealthId()` | [broker flow](health-id.md) -> `POST account/link/healthId` `{healthIdIdentityToken}` | links the provider to **this** account; a conflict is a message, never a silent switch |
| Add passkey - `addPasskey` | `POST account/link/passkeys/generate-options` `{}` -> `createCredential` -> `POST account/link/passkeys/verify` `{passkeyAttestation}` | |
| Change password - `changePassword` | `POST account/changePassword` `{identifier, oldPassword, newPassword, accessToken}` | Offered only when this installation registered the account with an email, which is the only password it can know: an account created with a passkey or Health-ID has none, and the profile does not report whether a password exists. `identifier` is that persisted email. Success ends the session; the user renews with biometrics. `ChangePasswordLoginRequired` -> back to biometric login with a message; nothing is replayed |
| Sign out - `signOut` | `POST auth/logout` `{id, accessToken}` | local state is cleared first; the call may fail |

Password fields are cleared after every action, on background, and when the session ends.

The card also tells the user why Health-ID or a passkey matters: "To use another device, connect
Health-ID or add a passkey first. Email and biometrics cannot add a new device." There is no unlink and
no "remove this device" - both are DevTools / tenant matters (a lost-device journey is still to be
defined).

## Tests

*required password action gates entry; change returns to login*, *expiry during signing prevents
sending a protected request*, *passkey registration and Health-ID linking preserve account identity*.
