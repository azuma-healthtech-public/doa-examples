# Account transfer from a previous identity provider (variant A)

Code: `lib/src/customer/journeys/transfer.dart`, `lib/src/core/transfer_provider.dart`,
`lib/src/customer/views/transfer_views.dart`. Spec: `variants.md`, section A.

The user signs in once at the provider they are leaving; DOA creates an account for that identity and
binds this phone; from then on the journey is the customer app's. Entered from the **Account transfer**
tile only - no other flow offers it - and every way of leaving it (back, "Not now", "This isn't me",
cancelling the hand-off) returns to the root.

## Screens

| | |
|---|---|
| A1 | What moves, what does not, what happens next; consent, unchecked, taken **before** the hand-off because the hand-off itself already sends data |
| hand-off | The provider's sign-in in the system browser: authorization code + PKCE, `state` and `nonce` from the platform CSPRNG, callback matched on scheme/host/port/path, `nonce` verified in the returned token. The same browser channel as Health-ID |
| A2 | The identity that came back, masked. "Create my account" registers; "This isn't me" leaves nothing behind |
| 6 | Mandatory biometrics, unchanged |

The identity lives in memory between A1 and A2 - never persisted, never logged - and is dropped when
the user confirms, declines, or leaves the screen.

## Registration and the record

`challenge/registration` -> device proof -> `account/register/<provider>` `{identityToken,
requestChallenge, language, deviceAttestation, androidIntegrityToken}` -> account id. The record gains
`transferredFrom` (a label) and `transferredAt`. If DOA returns a session with the registration the
user is signed straight in; otherwise the journey asks for one more sign-in, as Health-ID registration
does. A later sign-in through the provider is `auth/login/<provider>`, signed by the device key with
integrity data over its own challenge.

## What it cannot do, and why

DOA validates identity tokens for **Google and Apple only**, against their live signing keys and the
tenant's `ValidAudiences`; every other issuer is refused outright. And neither of those two issues a
public OAuth client with an https redirect and no secret - so the browser hand-off as built fits only
providers DOA does not accept yet. End to end, the journey runs today only with Health-ID standing in
as the previous provider. The generic case waits for per-tenant OIDC providers in DOA, with
`registrationOnly` and `AllowAddingNewDeviceOnlyOnRegistration`.

## Demo mode

`TRANSFER_DEMO=true`, in a **debuggable build only** (a release build folds the path away whatever the
define says), shows the screens without a provider: an in-app sheet stands in for the sign-in and
accepts anything typed, A2 shows it, and "Create my account (demo)" ends with a notice instead of
contacting DOA. Nothing is minted - it would be refused - and nothing is written, because there is no
account behind it. A demo identity is refused outside demo mode, so it can reach neither a real
hand-off nor DOA. Every demo screen says it is one, and the launcher tile reads "(Demo)".

## Tests

`test/transfer_flow_test.dart`: the hand-off alone creates nothing; "this isn't me" leaves no trace;
confirming registers the identity and records where it came from; a registration that returns a
session signs straight in; the record survives a restart; a later sign-in goes through the provider
route, device-bound; an unconfigured build refuses; a bound phone refuses; demo mode holds an identity
without a provider, ends before DOA, refuses a demo identity outside demo mode, and has no sign-in
behind it. `test/navigation_test.dart`: leaving the transfer returns to the launcher.
