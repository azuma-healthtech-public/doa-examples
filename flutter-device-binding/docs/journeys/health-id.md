# Health-ID broker flow

`lib/src/core/health_id.dart`, with `HealthIdChannel.kt` for the randomness and the browser
hand-off. Disabled (`configured == false`) until the Health-ID defines are set; see the README's
configuration table. The user chooses the insurer each time from the broker's directory
(`views/provider_picker.dart`); nothing is pinned into the build.

| Step | Where | What |
|---|---|---|
| 0 | Dart `providers()` | `GET HEALTH_ID_IDP_LIST_URL?relayingPartyId=…` when the picker opens -> `[{issuer, organizationName, pkv, …}]`. Entries without an https issuer or a name are dropped, the rest sorted by name. The user picks one and that issuer becomes `provider` below. Public, read-only, never cached to disk |
| 1 | Kotlin `createProof` | PKCE verifier (32 bytes, `SecureRandom`), S256 challenge, `state`, `nonce` |
| 2 | Dart | `GET HEALTH_ID_AUTHORIZATION_URL` with `client_id, redirect_uri, response_type=code, scope=openid urn:telematik:versicherter, provider, state, nonce, code_challenge, code_challenge_method=S256, response_format=json` -> `{url}` |
| 3 | Dart | reject the launch URL unless its scheme is `HEALTH_ID_AUTHENTICATOR_SCHEME` and not `http`/`intent`/`file`/`javascript`/`content`, and it has no userinfo |
| 4 | Kotlin `authorize` | `ACTION_VIEW` + `CATEGORY_BROWSABLE`; the result is pending until the app-link callback arrives in `MainActivity.onNewIntent` |
| 5 | Kotlin `handle` | the callback must match `HEALTH_ID_REDIRECT_URI` in scheme, host, port and path; Dart checks again and rejects a fragment |
| 6 | Dart | `POST HEALTH_ID_EXCHANGE_URL` `{clientId, redirectUrl}` (or `{clientId, code, state}` when `HEALTH_ID_EXCHANGE_VIA_REDIRECT=false`) -> `{redirectUrl}` |
| 7 | Dart `validateHealthCallback` | that URL must match the redirect URI exactly, carry exactly one `state` equal to ours, exactly one non-empty `code`, no `error`, no fragment, no userinfo |
| 8 | Dart | `POST HEALTH_ID_TOKEN_URL` form `{grant_type=authorization_code, client_id, redirect_uri, code, code_verifier}` -> `id_token` |
| 9 | Dart | the token's `nonce` claim must equal ours; the token is returned **unverified** - DOA is the relying party that validates it |

The callback is currently the React Native example's, `…/rn-ce/code/ce` on the mimoto domain, because
the gematik federation trusts that URI and not ours; the README explains the trade. Everything below is
unaffected by which URI it is - the match is exact either way.

Not every provider in the directory can be used by every relying party. One federated through gematik
resolves the relying party through the federation (`app-ref.federationmaster.de` on the reference
environment) and refuses a redirect URI the federation has not published, even when the broker's own
registration carries it. Step 2 then fails, the app raises `HealthIdProviderUnavailable`, and the user
is told to try another insurer rather than to check their details.

Cancellation: *Cancel Health-ID sign-in* is shown while the flow is active; it cancels the HTTP calls
and the pending browser result. A process death aborts the flow; a restart begins a new one with fresh
proof. The whole flow is bounded by timeouts (3 minutes for the browser). Tokens and callback
parameters never reach the UI or logs.

What the token is used for depends on the caller: [registration](registration.md),
[login](login.md), [second device](second-device.md) or [linking](account.md).

## Tests

*Health-ID rejects wrong state, duplicate code and foreign callback*, plus the journey tests that use
`TestHealth`.
