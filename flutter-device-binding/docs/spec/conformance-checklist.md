# BSI TR-03161-1 conformance checklist

Against **TR-03161-1 version 3.0** (25 March 2024), the mobile-application part. Each row: the clause,
which section of [customer-app.md](customer-app.md) answers it, and the evidence an evaluator needs.
"App" means the requirement is met by the app design; "backend" means DOA must supply it; "open" means
neither does yet. TR-03166 (biometric components) is a separate assessment and is not covered here.

**This is not a conformance claim.** It is the map from the guideline to the specification so that
the claim can be built, per platform, with device- and tenant-level evidence.

| Clause | Requirement (short) | Spec | Status | Evidence needed |
|---|---|---|---|---|
| O.Auth_1 | Documented concept for authentication, authorization, session end | 1, 3.1, 4 | App: this document | This spec + the platform's implementation notes. Note the BSI position that consumer biometrics reach at most "substanziell", not "hoch" - the concept must say so |
| O.Auth_2 | Authentication and authorization separated | 4.5 | App / backend | Per-request `accessToken` + device signature; backend role checks |
| O.Auth_3 | Every authentication is two-factor | P1, 4.2, 4.3 | App | Device key (possession) + password / passkey / Health-ID / biometric; two hardware signatures on a biometric login |
| O.Auth_4 | Lower-assurance methods only with consent | 7 | App: none offered | The customer profile offers none. Variant A takes O.Purp_3 consent on A1 before its hand-off; variant C runs at one server-verified factor and says so in its spec |
| O.Auth_5 | Extra signals in the auth decision | 3.3, 4.3 | App | Key invalidated on enrolment change; attestation and integrity token per request |
| O.Auth_6 | User can see login events | - | **Open (backend)** | No login history in the app or the API |
| O.Auth_7 | Brute-force protection | - | Backend | Tenant lockout / rate limiting evidence |
| O.Auth_8/9/10 | Re-authentication after background / idle / active time | P3, 3.1 | App | 10-minute cap, monotonic clock, resume check; test "expiry with activity and with backgrounding" |
| O.Auth_11 | Changing credentials requires re-authentication | 4.5 | App / backend | `ChangePasswordLoginRequired` handling; tenant policy |
| O.Auth_12 | Backend authentication | 3.6, 6 | App | TLS with platform trust; https-only base URL. **Pinning: see O.Ntwk_4** |
| O.Auth_13 | Auth data treated as sensitive | P4 | App | Token in memory only; nothing at rest; log inspection |
| O.Auth_14 | User can invalidate issued tokens | 4.5 | Partial | Sign-out revokes the current session; **global revocation and device removal: open** |
| O.Auth_15 | Backend told when a session ends | 3.1 | **Partial** | Explicit sign-out only; self-ended sessions are local (known gap) |
| O.Pass_1 | Strong password policy | 2.2 (3), 6 | Backend | Tenant policy; the app only shows strength |
| O.Pass_2 | Strength shown, not stored | 2.2 (3) | App | Meter is derived on device and never persisted |
| O.Pass_3 | Password can be changed | 4.5 | App | Screen 9 |
| O.Pass_4 | Changes logged, user informed on a separate channel | - | Backend | Tenant email on change |
| O.Pass_5 | Hashing on the server | - | Backend | DOA/Kratos configuration |
| O.Data_1 | Maximum security by default; minimal permissions | 6 | App | `INTERNET` only; no permission asked before use |
| O.Data_2 | Sensitive data encrypted; keys hardware-held | 3.2 | App | Store cipher and wrapping key; on-device inspection of the file |
| O.Data_3 | Sensitive data in protected areas | 3.2, 3.3 | App | Keys in secure hardware; record in the no-backup dir |
| O.Data_5 | Deleted when no longer needed | 3.1, 3.6 | App | Token dropped at expiry; fields cleared |
| O.Data_10 | No keyboard learning on secrets | 3.6 | App | Autocorrect and suggestions off on every field the app owns - secrets, e-mail, account name, code |
| O.Data_12 | Keys and biometrics never exported | P1, 3.3 | App | Non-exportable keys; only public keys, chains, signatures leave |
| O.Data_13 | No screenshots / recents thumbnails | 2.2, 3.6 | App | `FLAG_SECURE`; iOS: cover on resign-active (no screenshot block exists) |
| O.Data_15 | Local data device-bound | 3.2 | App | Wrapping key in hardware; excluded from backup |
| O.Data_16 | Data gone on uninstall | 3.2 | App | No-backup dir; keystore entries orphaned - note in evidence |
| O.Data_17 | User can delete all sensitive data | 7 | **Open** | Sign-out keeps the record and keys; a "remove this phone" action is not defined |
| O.Plat_1 | Device lock required, or the user is warned | P2 | App | Strong biometrics imply a lock screen |
| O.Plat_4 | No sensitive data in notifications/logs | P9, 3.6 | App | Release logcat / console inspection |
| O.Plat_9 | Sensitive data removed from views on background | 2.2 | App | Lock icon replaces the body; fields cleared |
| O.Plat_12 | User data overwritten at exit (SOLL) | - | Open | Not addressed; note in the risk assessment |
| O.Plat_13 | User informed of security measures they can take | 2.2 (1, 6) | Partial | Welcome and biometrics screens explain; **O.Resi_1 in-app guidance still open** |
| O.Ntwk_1/2 | Encrypted, mutually authenticated, state of the art | 3.6 | Partial | TLS 1.2+/platform; mutual auth via signed requests to DOA only - evaluator decides |
| O.Ntwk_4 | Certificate pinning | - | **Open** | Not implemented on any platform |
| O.Ntwk_5 | Server certificate validated | 3.6 | App | Platform trust store, no bypass |
| O.Ntwk_7 | Platform options (cleartext opt-out, ATS) | 6 | App | `usesCleartextTraffic=false` + https-only URL check; ATS default |
| O.Source_1 | Inputs validated | 4.6 | App | Callback/URL validation; code and email checks |
| O.Source_3 | No sensitive data in errors/logs | P9 | App | Fixed messages; log inspection |
| O.Source_4 | Exceptions handled, no stack traces to users | 3.5 | App | The run loop maps every error |
| O.Source_8 | No dev options in production | P10 | App | Release artefact string search (done for Flutter) |
| O.Source_9 | Obfuscation, stack protection (SOLL) | - | Partial | R8 on Android; Dart `--obfuscate --split-debug-info` in both release workflows, symbol maps kept as run artifacts; iOS default |
| O.Source_10 | Static analysis | 8 | App | Analyzer/lint in the checklist |
| O.Resi_1 | Best-practice guidance in the app | - | App | S3 "Keep your phone safe", from the welcome and account screens |
| O.Resi_2 | OS state checked via platform, user told of risk | 3.4 | App / backend | Integrity token on every request; the O.Resi_2 message; **backend must enforce (AP-481) and read root-of-trust (AP-482)** |
| O.Resi_3/4 | Detect debug environment / unusual privileges, exit | - | **Open** | Not implemented; Play Integrity covers part of it server-side |
| O.Resi_6 | Backend authenticity before access | 3.6 | Partial | TLS; pinning open |
| O.Resi_8 | Anti reverse engineering | - | Partial | See O.Source_9 |
| O.Resi_10 | Robust against disruption | P8, 3.2 | App | Fail-closed storage; serialised writes; retry states |
| O.Cryp_1..5 | No hard-coded secrets; proven primitives; strength per TR-02102-1 | 3.2, 3.3 | App | EC P-256, AES-256-GCM, RSA-4096 wrap; SHA-1 MGF1 fallback below API 34 is a documented deviation |
| O.Cryp_6/7 | Keys and operations in a protected environment | P1 | App | TEE/StrongBox/Secure Enclave; software keys refused |
| O.Rand_1 | CSPRNG | 4.6, platform-mapping | App | `SecureRandom` / `SecRandomCopyBytes` / `Random.secure()` |
| O.Arch_4 | No plaintext in backups | 3.2 | App | Backup excluded |
| O.Arch_6 | Integrity via signature | - | App | Platform code signing; Play/App Store |
| O.Arch_10 | Forced updates (SOLL) | - | Open | Not implemented |
| O.Purp_1 | Purpose disclosed before install and at first use | 2.2 (1) | Partial | Store listing + welcome; privacy notice link |
| O.Purp_3 | Explicit consent before processing personal data | 2.2 (3) | App | Consent checkbox, unchecked by default, on every registration path |
| O.TrdP_1..8 | Third-party inventory, currency, maintenance | 5, platform-mapping | App | No UI kit; per platform the dependency list is short and named; library evaluation recorded in AP-483 |

## Backend findings that block a claim (tracked)

- **Backend, integrity-token freshness** - Play Integrity login tokens are not bound to the single-use login challenge and not
  checked for freshness: replayable until fixed. The app already sends the right values.
- **Backend, attestation reading** - key attestation is not checked for root of trust or app identity; the biometric key's
  attestation is not read. The app already sends `keyAttestation`.
- **Passkey origin** - DOA accepts the client-asserted origin; Android/iOS enforce it instead. A
  server-side allowlist is needed for the WebAuthn phishing-resistance property.
- **Tenant defaults** - `AllowedSecurityLevels` includes `Software`; every integrity enforcement
  switch is off. A conformant tenant configuration is part of the evidence.
