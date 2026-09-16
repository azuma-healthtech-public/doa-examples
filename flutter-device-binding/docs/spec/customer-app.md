# DOA customer app - specification

Status: approved flow (design canvas v8, 2026-09-12); reference implementation
`examples/flutter-device-binding` (see section 9). Platform-neutral; see [platform-mapping.md](platform-mapping.md) for
what each requirement lands on per platform.

## 1. Purpose and principles

One customer-facing app that creates and uses an account on the DOA Device Binding API, for a health
application that must hold to **BSI TR-03161-1**. Email, passkey and Health-ID are alternative entry
points into the *same* account; a second phone is added through passkey or Health-ID; biometrics are
mandatory on every phone; sessions are fixed at ten minutes.

Non-negotiable, on every platform:

| # | Principle | Why |
|---|---|---|
| P1 | **A hardware-bound device key signs every request after registration.** Created in the platform's secure hardware with a server challenge as attestation challenge; the attestation chain is sent once, at binding. Never exportable, never overwritten. | The binding *is* the possession factor (O.Auth_3, O.Cryp_6/7, O.Data_12) |
| P2 | **Biometrics are mandatory**, per use, hardware-enforced, invalidated when the enrolment changes, and the biometric key is attested too. No skip, no "later". | O.Auth_3, O.Auth_5; customer policy |
| P3 | **Sessions are fixed at 10 minutes** from a successful backend login, or the token's own expiry if earlier, checked against a monotonic clock as well as wall time. No refresh token, no `offline_access`, no sliding window. Only a biometric login starts the next session. | O.Auth_8/9/10; customer policy |
| P4 | **Identifiers only at rest.** The secure store holds key aliases, the account id, the email, a verification-flow id. Never a password, never a token. The access token lives in memory; restart means login. | O.Data_2, O.Auth_13 |
| P5 | **Signed bytes are sent bytes.** The payload is serialised once, signed, and that string is sent. Passkey options and responses pass through unparsed. | The RP verifies exactly what it issued |
| P6 | **Every server challenge is single-use** and covers exactly one thing: one attestation, one integrity token, one biometric signature. Fetched per request, never cached. | Replay (AP-481) |
| P7 | **Device integrity on every binding and every device-bound login**: a platform integrity token (Play Integrity / App Attest) over the request's own challenge, sent alongside the attestation or inside the signed payload. Requested *before* a key is created, and *after* a biometric prompt (freshness). | O.Resi_2 |
| P8 | **Fail closed.** Unreadable storage is an error, never a fresh install. A missing integrity token, a software-backed key, an unavailable channel - each stops the journey with a message; nothing degrades. | O.Resi_10, O.Source_5 |
| P9 | **Nothing from the backend is echoed to the user**; every error maps to a fixed user-facing message. No request/response logging in the customer app, in any build. | O.Source_3, O.Plat_4 |
| P10 | **No developer affordances in the reviewed binary.** Diagnostics, local reset, runtime backend override exist only in debug builds, behind a compile-time constant, and are verified absent from the release artefact. | O.Source_8 |

## 2. Screens and flow

Frame: phone portrait. Numbers are the canvas numbers. No fake status bar or keyboard in mockups; real
ones render on top.

### 2.1 The state gate

One entry, no routes around it. On every render, in this order, the first true state wins:

```
storage unreadable         ->  S0  Retry            fail closed; never silently a fresh install
no session                 ->  1 / 2a / 2b / 2c      entry
email unverified           ->  4  Verify email
no biometric key           ->  6  Enable biometrics  cannot be skipped
blocking post-login action ->  S1 Maintenance message
password change required   ->  9  Change password
otherwise                  ->  8  Account & security
```

Which entry screen shows depends on the phone, not on a user choice: **no device record** on this
installation -> 2b (only passkey and Health-ID can add a phone); **record present** -> 2c. A session
that ended -> 7. The welcome screen (1) is shown when there is no record and the user has not chosen.

**Screen 0 - Start, the example launcher.** The example apps open on a launcher that lists the
flows (the customer app and the [variants](variants.md)); tapping one starts that flow on its own
welcome screen. Each flow keeps its own device record (`customerDevice.v1.<profile>`), so the flows
behave like separate installs on one phone. The launcher exists **only when no profile is pinned at
build time**: a build with `PROFILE=customer` opens on screen 1 and contains no launcher - that is the
binary an evaluator reviews. It also shows the backend host, application id and build type, so a
tester can tell which environment a screenshot came from.

### 2.2 Screen catalogue

| # | Screen | Purpose | Must have | Must not have |
|---|---|---|---|---|
| 0 | **Start** (examples only) | Launcher listing the flows, the reference one first. Absent when a profile is pinned at build time. | One tile per flow, all of them reachable, each with its own device record; environment line | Any account or session content |
| 1 | **Welcome** | First open on a fresh install. States the offer in one line and one proof line each for the three principles the user will feel (device-bound, biometrics + 10 min, three ways in). Logo. | Primary **Create account**, secondary **Sign in**; links to privacy notice and imprint | Any form; any marketing filler |
| 2a | **Create account** | Choose the method: email + password, passkey, Health-ID. Three-step explainer: create, set up biometrics (required), confirm every 10 min. | Link "Already have an account? Sign in" | A username option (see AP-485 for optional tenant methods) |
| 2b | **Sign in - new phone** | The installation has no device record. Explains that a passkey or Health-ID can add this phone and that email alone cannot. Offers exactly those two. | The explanation, visibly; "New to azuma? Create account" | Email / password; biometrics |
| 2c | **Sign in - linked phone** | Record present. Greeting with masked email; **biometrics is the primary action**; email, passkey, Health-ID beneath a divider. | "Not you? Remove this account from the phone" | Anything that extends a session |
| 3 | **Email registration** | Email, password with strength meter and show/hide, confirm password, **explicit consent checkbox** (privacy notice, health-data processing). | Consent unchecked by default; strength shown, never stored | Prefilled credentials; a "remember me" |
| 3p | **Name your account** (passkey) | The identifier the account needs before a passkey is created. States that the name is shown next to the passkey and is not a secret. | Field with helper; what the phone will ask next | A dialog; a password |
| 4 | **Verify email** | 6-digit code sent to the address; resend with countdown. Reached from 3 and from the gate on any later launch while unverified. | Masked address shown; retry after wrong code | Skip |
| 5 | **Email sign-in** | Address read-only (it is the record's), password, forgot-password link. | "This phone is linked to this account" helper | Editable address |
| 6 | **Enable biometrics** | Required step after registration by any method and after adding a phone. Explains the key is created in the phone's secure hardware, is bound to the enrolled biometrics, and must be redone if they change. | One primary action; "This step can't be skipped" | Back, skip, cancel-to-account |
| 7 | **Session ended** | Full-screen lock state after 10 minutes. Dark surface on purpose - it is a state, not a page. | **Unlock with biometrics** primary; "Sign in another way"; **Sign out**, which returns to the root (screen 0 in the examples, screen 1 in a pinned build) | Any account content; any way to extend |
| 8 | **Account & security** | Signed in and complete. Session countdown chip in the app bar. Sign-in methods: Biometrics (this phone, enabled), Passkeys (n, add), Health-ID (connect / connected). Why Health-ID or a passkey matters before a second phone. Change password **only when the account has a password**; email (verified); **Sign out** in error colour, returning to the root. | Countdown visible; the second-phone explanation | Unlink (DevTools / support), remove-device (not defined yet); a change-password entry on an account created with a passkey or Health-ID |
| 9 | **Change password** | Current, new with strength, confirm. Reached from 8 and from the gate when the backend requires a change. On success the session ends and 9b follows. | Fields cleared after every action and on background | Replaying a submission after a re-login; asking which account to change, since the app already knows |
| 9b | **Password changed** | The confirmation, on its own screen so it is read before the sign-in screen replaces it: the new password is in place, sign in again to continue. Primary **Continue** to screen 1 - on a bound phone that is 2c, "Welcome back". Back does the same. | Nothing to type; one way forward | Any way to stay signed in; the old session |
| H1 | **Choose your insurer** (Health-ID) | The broker's provider directory, searchable. Opens over the current screen from registration, from sign-in and from the account screen, so it is a picker and not a state of the gate. | Search; the count is in the hundreds; a retry when the directory cannot be read | A provider pinned into the build; a logo fetched from the provider before the user has chosen |
| H2 | **Hand-off to the insurer** | What stays behind while the insurer's page or app is in front: the screen that started the flow, its Health-ID entry marked with the chosen insurer, a progress bar and a cancel. | Cancel, always, changing nothing; a line saying the insurer takes over and the user comes back | A fake browser frame; any claim that something has been saved |
| S0 | Storage unreadable | "Secure storage could not be read. Retry before continuing." | Retry | Reset, reinstall advice inside the app |
| S1 | Maintenance | A blocking post-login action the app does not implement (anything but password change and nearing-expiration). | Contact-provider message | A way through |
| S2 | Device check failed | The integrity check was rejected (modified phone) or could not be made. Names the risk, says the account and other phones are unaffected. | **Check again** (re-runs the action); the risk, in plain words | A way through; the backend's text |

Transitions the platform must guarantee: **6 has no back**; 7 replaces the whole UI; the body is hidden
(lock icon) whenever the app is not in the foreground; password fields are cleared on background and
after every action; screenshots and recents thumbnails are blocked app-wide.

## 3. Policies

### 3.1 Session

- Starts only on a successful backend login or a token-returning registration. Deadline = the earliest
  of now + 10 min, the token's `exp`, and `expiresIn`. Valid while wall time is before the deadline
  **and** a monotonic clock is under 10 minutes.
- Checked before every protected request, again after the asynchronous signature and before the
  network, on every response, on app resume, and by a foreground timer.
- At expiry: token and profile dropped, `reauthenticationRequired` set, screen 7. Only a biometric login
  clears it; every other method is refused with "Use biometrics to renew this session".
- Sign-out calls `auth/logout` and clears local state even if that call fails.
- Known gap, backend: the app tells the backend only on explicit sign-out; sessions it ends itself
  (expiry, after biometric setup, after a password change) are dropped locally (O.Auth_15).

### 3.2 Storage

One record, versioned (`customerDevice.v1`): device-key alias, account id, email, biometric-key alias,
verification-flow id. Written as one unit; writes serialised; a timed-out write never races a retry.
Sealed with an authenticated cipher under a hardware-held wrapping key of at least the strength
TR-02102-1 asks of new systems (Flutter: AES-256-GCM under RSA-4096 in the TEE). Excluded from backups.
A record that cannot be decrypted is reported, never deleted (P8).

### 3.3 Keys and attestation

| Key | Created | Attested over | Sent as | Purpose |
|---|---|---|---|---|
| Device key `customer.device.<random>` | first registration or adding this phone | the `registration` / `additionalDevice` challenge | `deviceAttestation.attestation` | signs every device-bound request |
| Biometric key `customer.biometric.<random>` | "Enable biometrics" | the `linking` challenge | `publicKey` + `keyAttestation` | per-use biometric proof; read by DOA once AP-482 lands |
| Storage wrapping key | first launch | - | never leaves the device | seals the record |

Aliases are random; a `customer.*` alias is never replaced. A definitive rejection of a new binding
(400/403/409/422) clears the pending record so a new key can be tried; an ambiguous failure (timeout,
5xx) keeps it, because the server may have accepted the attestation.

### 3.4 Device integrity

Every registration and second-phone enrolment sends an integrity token over `requestChallenge` (the
same challenge the device key is attested over). Every device-bound login sends
`deviceBoundIntegrityVerificationData: {challenge, androidIntegrityToken}` (iOS: the App Attest
assertion) inside the signed payload, over the login challenge. Order: for a binding the token comes
first, before any key exists; for a biometric login it comes after the prompt, so it is milliseconds old
when sent. The device never interprets the verdict. A rejection shows the O.Resi_2 message and grants
no session; a rejected registration leaves nothing pending.

### 3.5 Errors and messages

Design canvas page "Errors and messages". Every message is one of four things, chosen by what the
user has to do about it, never by where the code caught it:

| Kind | When | Where | Anatomy |
|---|---|---|---|
| **Banner** | The outcome of an action | Top of the content, directly under the app bar and above what the user tried; on hero screens (1, 2c, 6, 7) directly above the primary action. Never at the bottom, never below the fold | Radius 12, padding 14/16, 20 px icon top-aligned, optional title 15/600, body 14/20, at most one text action ("Try again" re-runs the action). No close button: it clears when the next action starts or the screen changes. Live region |
| **Field error** | Anything the user can fix by typing: format, mismatch, empty | Under the field, replacing the helper line | 2 px error-500 outline, label and trailing icon in error 500, 12 px message with a 14 px icon. Checked on submit, cleared when that field changes. The button stays enabled; validation never uses the banner |
| **Full-screen state** | The journey cannot continue on this phone | Replaces the content | S0 storage unreadable, S2 device check failed, S1 maintenance |
| **Snackbar** | A confirmation nobody has to read | Bottom, 4 s | "Signed out", "Passkey added", "Health-ID connected" |

Banner tones: **error** (error 50 / 500) only when an action did not happen, and it always says what
did not change and what to do next; **warning** (warning 50 / 700) for a decision with a cost, before
the user continues; **info** (primary 50 / 700) when the user cancelled or needs context, so a
dismissed prompt is never red; **success** (success 50 / 500) for something the user must read, such
as "we sent a code".

Classification, on every platform: a prompt the user dismissed (passkey sheet, biometric prompt,
Health-ID browser) is info; a prompt the phone or the server rejected is error; a request that got no
answer is error with "Couldn't reach azuma" and "Try again"; a request the server rejected is error
without retry; 401 ends the session and asks to sign in again; an integrity rejection or an
unavailable integrity service is S2. Backend text is never shown (it may contain what the user typed);
the app keeps a fixed catalogue, one entry per cause, not per endpoint. Copy: title says what did not
happen in the user's words, body says what changed (usually nothing) and one next step, two sentences,
no exclamation marks. A failed profile load is an unknown state with Retry, never "no credentials".

### 3.6 Privacy, logging, display

No request/response logging in any build. Logs never carry tokens, challenges, key material or
identifiers. A debug build may name **what it is doing**, because a flow that spans a browser, an
authenticator app and two servers cannot be diagnosed from the outside otherwise: the step it is on,
the scheme, host and path of a callback it received but never its query, the backend's fixed error
code but never the backend's message, and the fixed title of the notice the user is about to see.
Release builds say none of it, and that must be verified in the artefact rather than assumed. Screen capture blocked (`FLAG_SECURE` / iOS equivalent); body replaced by a lock icon when
not in the foreground; secret fields with autocorrect and suggestions off. Consent is explicit and
unchecked by default; the privacy notice is reachable from the welcome screen.

## 4. Journeys and API sequences

Endpoints are `POST /deviceBinding/<area>/v1/mobile/<applicationId>/<action>`, written
`<area>/<action>`; challenges are `GET .../challenge/v1/mobile/<applicationId>/<kind>`, written
`challenge/<kind>`. **Signed** = the device-bound envelope `{payload, signature, deviceOs}`. **Device
proof** = `deviceAttestation` + `androidIntegrityToken` (or the iOS equivalents) over the same challenge.

### 4.1 Create an account

Preconditions before anything is created: storage readable; no record on this installation; strong
biometrics available. Then, for all three: persist the pending record before the request that can fail.

| Method | Sequence |
|---|---|
| Email | `challenge/registration` -> integrity token -> device key with that challenge -> `account/register/email` `{email, password, language, initiateEmailVerification: true, requestChallenge, deviceAttestation, androidIntegrityToken}` (unsigned) -> persist `id`, `verificationFlow` -> screen 4 |
| Passkey | `account/register/passkeys/generate-options` `{identifier}` -> platform `createCredential(options)` -> `challenge/registration` -> device proof -> `account/register/passkeys/verify` `{identifier, passkeyAttestation, deviceAttestation, androidIntegrityToken, requestChallenge, loginScope: "", language}` -> returns `id` **and** a token -> session -> screen 6 |
| Health-ID | broker flow (4.6) -> `challenge/registration` -> device proof -> `account/register/healthId` `{identityToken, requestChallenge, language, deviceAttestation, androidIntegrityToken}` -> persist `id` -> user signs in with Health-ID -> screen 6 |

Email verification: `account/verify/email/confirm` `{email, verificationFlow, verificationCode}` (signed);
resend `account/verify/email/initiate` `{email}` (signed). Cancelling a passkey sheet leaves nothing
behind.

### 4.2 Sign in on a linked phone

All signed; all fetch `challenge/login` and carry `deviceBoundIntegrityVerificationData` over it.

| Method | Call |
|---|---|
| Email | `auth/login/email` `{email, password, scope: "", requestChallenge, deviceBoundIntegrityVerificationData}` |
| Passkey | `auth/login/passkeys/generate-options` `{identifier?}` -> `getCredential` -> `auth/login/passkeys/verify` `{identifier?, assertion, scope, requestChallenge, deviceBoundIntegrityVerificationData}` |
| Health-ID | broker flow -> `auth/login/healthId` `{identityToken, scope, requestChallenge, deviceBoundIntegrityVerificationData}` |
| Biometrics | see 4.3 |

Completing a login: the token's `sub` must equal the record's account id; deadline per 3.1; a
`refreshToken` in the response is discarded; `postLoginActions` gate entry.

### 4.3 Biometrics

Setup (session required): `challenge/linking` -> biometric key generated with it as attestation
challenge (per-use auth, strong biometrics, invalidated on enrolment change; refuse if not hardware-
enforced) -> prompt signs the challenge -> `account/link/biometrics` `{publicKey, keyAttestation,
requestChallenge, requestSignature, id, accessToken}` (signed by the device key) -> persist the alias ->
drop the session -> a real biometric login proves the link before entry.

Renewal: `challenge/login` -> prompt signs it with the biometric key -> integrity token over the same
challenge -> `auth/login/biometrics` `{id, requestChallenge, requestSignature, scope: "",
deviceBoundIntegrityVerificationData}` (signed by the device key). Two hardware-bound signatures reach
the server; a local prompt success alone is never a login.

Repair: when the key stops working (enrolment changed), "Repair biometric setup" clears the local alias
and grants nothing; the user signs in with another method and completes setup again.

### 4.4 Add a second phone

Only from 2b, only passkey or Health-ID. Registration shape against `device/register/*` with an
`additionalDevice` challenge; both return a token, then screen 6 on this phone.

| Method | Sequence |
|---|---|
| Passkey | `device/register/passkeys/generate-options` `{}` -> `getCredential` -> `challenge/additionalDevice` -> device proof -> `device/register/passkeys/verify` `{assertion, scope: "", requestChallenge, deviceAttestation, androidIntegrityToken}` |
| Health-ID | broker flow -> `challenge/additionalDevice` -> device proof -> `device/register/healthId` `{identityToken, scope: "", requestChallenge, deviceAttestation, androidIntegrityToken}` |

The account id in the token becomes this phone's id and must equal the first phone's. Nothing is
copied between phones. An email-only account must add Health-ID or a passkey on the first phone before
this is possible; a lost first phone with neither needs a recovery journey that is **not defined yet**.

### 4.5 Account & security

Every call is signed, carries `id` and `accessToken`, and is allowed only while the session that
started it is still the current, valid one.

| Action | Call |
|---|---|
| Load profile | `account/userInfo` `{}` |
| Add Health-ID | broker flow -> `account/link/healthId` `{healthIdIdentityToken}` - links to **this** account; a conflict is a message, never a switch |
| Add passkey | `account/link/passkeys/generate-options` `{}` -> `createCredential` -> `account/link/passkeys/verify` `{passkeyAttestation}` |
| Change password | `account/changePassword` `{identifier, oldPassword, newPassword, accessToken}` -> session ends -> 9b, then screen 1 -> biometric login. `ChangePasswordLoginRequired` -> back to biometric login with a message; nothing is replayed |
| Sign out | `auth/logout` `{id, accessToken}`; local state cleared first; the app returns to the root (screen 0 in the examples, screen 1 in a pinned build) |

**Password change is not offered to every account.** An account created with a passkey or with
Health-ID has no password, so there is nothing to change and the entry is absent from screen 8 rather
than present and failing. The app decides this from what the installation knows: it holds an email
only when it registered the account with one. The profile endpoint does not report whether a password
credential exists - it returns linked OIDC providers, passkeys and biometric credentials, and nothing
about email or password - so an installation that joined an existing account through a passkey or
Health-ID cannot tell either, and offers no password change. Erring towards absent is deliberate: the
alternative sends the user into a form that cannot succeed. A `hasPassword` flag on the profile would
let every installation decide correctly; until then this is the honest approximation.

### 4.6 Health-ID broker flow

Screens: the caller (2a, 2b, 2c or 8) -> **H1** choose the insurer -> **H2** while the system browser
or the insurer's app is in front -> back to the caller, and from there into 6 Enable biometrics on any
path that created or bound an account. Cancelling at any point returns to the caller and changes
nothing.

The user picks the identity provider first: `GET` the broker's directory for this relying party, drop
entries without an https issuer or a display name, sort by name, and let the user search. That call is
public and read-only, carries nothing about the user, and its result is not cached to disk, because a
stale entry sends someone to an identity provider that no longer federates. The chosen issuer is the
`provider` parameter below. Then: PKCE (S256) verifier, `state`, `nonce` from the platform CSPRNG ->
`GET` the broker's authorization
endpoint with `client_id, redirect_uri, response_type=code, scope=openid urn:telematik:versicherter,
provider, state, nonce, code_challenge, code_challenge_method=S256,
response_format=json` -> reject the launch URL unless its scheme is the configured one and not
http/intent/file/javascript/content -> system browser -> app-link callback matched on scheme, host,
port, path (no fragment) -> exchange endpoint `{clientId, redirectUrl}` (or `{clientId, code, state}`)
-> the returned URL must match the redirect URI exactly, carry exactly one `state` equal to ours and
exactly one non-empty `code`, no `error` -> token endpoint (form) `{grant_type=authorization_code,
client_id, redirect_uri, code, code_verifier}` -> `id_token` whose `nonce` equals ours -> handed to DOA
**unverified**: DOA is the relying party. Cancellable; a process death aborts; restart begins anew with
fresh proof. Tokens and callback parameters never reach the UI or logs.

## 5. Design

Source of truth: azuma corporate design system (`azuma-homepage/tailwind.config.js`) mapped onto the
platform's standard component library. **No third-party UI kit**; the platform's own components,
re-coloured. Figtree for everything (fallback: the platform system font); a monospace face only for
ids and codes.

| Role | Token | Hex |
|---|---|---|
| Primary (fills, icons, links) | primary 400 | `#3e86a3` |
| On primary container; lock-screen surface | primary 700 | `#1b445a` |
| Primary container, tonal buttons, tile leading | primary 100 | `#d9ecf2` |
| Info banner surface | primary 50 | `#f0f7fa` |
| Error / secondary (fills) · as text on white | error 400 · 500 | `#fd2c4e` · `#e01040` |
| Success (icons) · as text on white | success 400 · 500 | `#3a9e8f` · `#2a7e72` |
| Warning banner | warning 400 / 50 / 700 | `#e6a914` / `#fef9ec` / `#754f05` |
| On surface / body / secondary / placeholder | neutral 900 / 600 / 500 / 400 | `#161d24` / `#4d5a68` / `#637180` / `#84939f` |
| Outline / outline variant / divider | neutral 300 / 200 / 100 | `#adb8c4` / `#d1d8e0` / `#eaedf1` |
| Surface / surface container | neutral 0 / 50 | `#ffffff` / `#f5f7f9` |
| Dark screen text / links | primary 200 / 300 | `#b0d6e4` / `#7ab9d0` |

Rule for the two reds and greens: the 400 step is the brand value for fills and icons; the 500 step is
the same hue used as text on white, where 400 does not reach 4.5:1.

Shape and type: buttons 48 (56 for the one primary action on a screen), pill; text fields 56, radius 8,
outline 300, focus 2 px primary; method tiles radius 12 on surface container with a 40 px tonal leading
circle; top app bar 64, title 22/500; headline 28/36 700 (welcome 30/38, greeting 24/30); body 16/26;
helper 12/16; touch targets >= 48 everywhere; icons stroke-based, one family.

Copy: short, second person, "phone" (not "device"), "sign in" (not "log in"), no exclamation marks, no
marketing filler. State what the user gets and what the app will not do.

## 6. Configuration and tenant

Build-time (compile-time constants; a build cannot be repointed): backend base URL (https only),
application id, integrity project (Play) / team id (App Attest), and the Health-ID broker set (six
values; the flow is disabled until all are set). Runtime override exists only in debug builds.

Tenant (DOA admin): 10-minute access tokens; email/passkey/Health-ID/biometrics enabled; passkey RP
domain with `assetlinks.json` / `apple-app-site-association` listing every signing certificate in use;
`AllowedSecurityLevels` without `Software`; the integrity service account and package/bundle id; the
integrity enforcement switches on registration and every login method. Every enforcement switch
defaults to off - the app sends tokens either way.

## 7. What the app deliberately does not have

Refresh tokens; stored passwords; username or account-id login (planned tenant options); a
runtime backend switch or diagnostics in release; unlink or remove-this-phone in the customer UI;
a recovery journey for a lost phone without Health-ID or passkey (not defined yet); social sign-in
(lower assurance under O.Auth_4; product decision).

"Not you? Remove this account from the phone" on 2c forgets the *local* record only (the binding stays
on the server, the phone becomes a new device); it is not a remove-device operation.

Journeys that deliberately depart from this profile - account transfer from a previous identity
provider, OIDC registration, username with login by id - are specified as deltas in
[variants.md](variants.md), each with what it costs in assurance.

## 8. Acceptance checklist

Per platform, on a physical device, against a configured tenant, with the release build:

- [ ] All three registration methods; all four sign-in methods; each link operation preserves the account id
- [ ] Restart requires login and keeps the record; sign-out and sign-in; expiry after exactly 10 minutes with activity and with backgrounding; early token expiry; cancelled, failed and offline biometric login stay locked
- [ ] Wrong password, invalid and expired code, provider cancellation, passkey cancellation, biometric cancellation and invalidation, no network - each leaves a usable screen and never a half-state
- [ ] Duplicate submission and an interrupted registration never overwrite a working device key
- [ ] Password change after a fresh login and when a new biometric login is required
- [ ] Second phone via passkey and via Health-ID, then mandatory biometrics on it; email and biometrics cannot enrol it; the first phone still works
- [ ] No refresh scope requested, no refresh token stored, no refresh endpoint called; nothing sensitive at rest or in logs (inspect both)
- [ ] Integrity: a genuine device passes; a rooted/jailbroken or bootloader-unlocked one is refused with the risk message
- [ ] Debug-only affordances absent from the release artefact (string search)
- [ ] Analyzer/linter clean; unit tests for every journey with faked platform channels; debug and release builds

## 9. Implementation status

| Stack | State | Ticket | Deviations from this document |
|---|---|---|---|
| Flutter (`examples/flutter-device-binding`) | Implemented on Android and iOS: screens 0-9, 9b, H1, H2, S0, S1, S2, S3; variant A (A1, A2, with a debug-only demo mode) and variant C (C1, C2, 8-lite, 7-lite; Android only); messages per 3.5 (`Notice` with tone, banner placement, field errors, snackbar); theme from the token table; Figtree bundled; launcher and DevTools compiled out of a `PROFILE=customer` release build; Dart obfuscated in release | AP-486 | Screen 4 resends without a countdown (DOA defines no cooldown; nothing to count against). Screen 5 "Forgot password?" shows "not available in this example yet" (no reset journey in DOA's mobile API). Screen 8 loads the profile automatically once per session. The privacy notice and imprint links on screen 1 are placeholders. Variant B is specified only. Variant A runs end to end only with Health-ID as a stand-in provider (see variants.md) |
| Kotlin | Not started | - | |
| Swift | Not started | - | |
| React Native | Not started | - | |

An implementation is complete when every row of the screen catalogue has a screen, the transitions
under 2.2 hold, section 8 passes, and the profile pin removes the launcher from the reviewed binary
(verified by string search in the release artefact).
