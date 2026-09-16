# Phone key: username once, then this phone is the key (variant C)

Code: `lib/src/customer/journeys/phone_key.dart`, `lib/src/customer/views/phone_key_views.dart`,
`DeviceBindingChannel.kt` (the gated key and the prompt). Spec: `variants.md`, section C.

The lightest account DOA supports. A username and a password once, and from then on this phone signs
the user in: `auth/login/id` takes the account id and is authenticated by the bound device key alone -
no password, no identity token. **Android only**; iOS refuses the profile and says why (below).

## The key, which is the whole point

In this profile the **device key itself** is generated with user authentication required, strong
biometrics only, invalidated when enrolment changes, and a 600-second authentication validity
(`setUserAuthenticationParameters(600, AUTH_BIOMETRIC_STRONG)`). The secure hardware refuses to sign
without a strong biometric inside that window; a boolean "biometric check" in front of an ungated key
would be a promise the app could skip.

What the window does *not* deliver on its own is a prompt per session: Android opens it on **any**
strong-biometric authentication, unlocking the phone included, so a sign-in shortly after unlocking
the phone would pass silently - which is what the first device test showed. The journey therefore runs
the prompt itself at every `login/id` (`DeviceBinding.unlock`, the `unlock` channel method: the
strong-biometric prompt on its own, no `CryptoObject`, since that binding is for per-use keys and a
time-bound key rejects it) and signs afterwards. Two layers, two promises, both true: the prompt is
what the session promises, the gated key is what the hardware enforces, and the app cannot skip the
second even if it forgot the first.

## Screens and sequence

| | |
|---|---|
| C1 | Username, password, confirm, consent; the warning that there is no e-mail to reset the password with. **No biometric is asked here**: creating a gated key needs no authentication, only using it does, and `register/username` is unsigned |
| C2 | "This phone is your key". Primary **Unlock** - the first sign-in and the account's **first prompt**. No skip |
| 8-lite | Username, "this phone is your key", add a passkey, change password, sign out |
| 7-lite | The lock screen with **Unlock** running `login/id`; no biometric setup to repair, because there is no second key |

Registration: `challenge/registration` -> integrity token -> gated device key -> attestation ->
`account/register/username` -> account id. Every login, including the first: `challenge/login` -> the
prompt -> integrity token (after the prompt, so it is fresh) -> `auth/login/id` `{id, scope: "",
requestChallenge, deviceBoundIntegrityVerificationData}` signed -> session. Another phone: username and
password once on the new phone, `device/register/username`, and a gated key of its own.

The record keeps `username` and no `biometricAlias`; the password is never stored. `changePassword`
uses the username as the identifier, since there is no e-mail.

## What the server sees

One factor. That the key is biometric-gated is written into its attestation chain, which DOA does not
read yet; once it does, a tenant can require a gated device key and this profile becomes
server-verifiable two-factor without a protocol change. Until then it is for tenants outside the DiGA
scope or willing to run at a lower assurance level with O.Auth_4 consent.

## iOS

The iOS device key is an App Attest key, which cannot be biometric-gated, and the Secure Enclave key
the spec suggests is not what DOA validates on iOS. So the profile refuses on iOS with a message that
says why, rather than gating in software and calling it hardware-enforced. Making it real there is a
backend question: DOA accepting a Secure Enclave signature as the device proof.

## Tests

`test/phone_key_flow_test.dart`: registration asks for a gated key; the username is sent and kept and
no password is ever persisted; every login is the device-bound `login/id` with no secret in it; every
session start prompts, and the account gate wants no second key; the unlock renews an ended session;
another phone gets its own gated key; the username survives a restart; empty details are refused before
anything is created. The prompt, the 600-second window and the enrolment-change invalidation are the
keystore's behaviour and need a phone to see.
