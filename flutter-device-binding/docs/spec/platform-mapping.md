# Platform mapping

What each requirement of [customer-app.md](customer-app.md) lands on, per platform, with the traps
already found. Fill in your column before writing code. "Reference" points at where the working code
is today.

| Requirement | Android (Kotlin) | iOS (Swift) | React Native | Flutter (reference) |
|---|---|---|---|---|
| **Device key + attestation** (P1) | `KeyPairGenerator` EC P-256 in `AndroidKeyStore` with `setAttestationChallenge(challenge)`; export `getCertificateChain`, encode base64(comma-joined base64 DER) | Secure Enclave key via `DCAppAttestService.attestKey` (App Attest); `hwKeyId` + attestation object; DOA validates with the team/bundle id | vendored `io-react-native-integrity` (`getAttestation`) on Android; App Attest on iOS | `DeviceBindingChannel.kt` + `core/device_binding.dart` |
| Reject software-backed keys | `KeyInfo.isInsideSecureHardware` / `securityLevel >= TEE` after generation; delete and throw otherwise | Secure Enclave keys are hardware by construction; App Attest fails on unsupported devices | same as native | `DeviceBindingChannel.kt` (`customer.*` aliases) |
| **Signing the envelope** (P5) | `Signature SHA256withECDSA` over the exact JSON string; base64 | `SecKeyCreateSignature` ECDSA-SHA256 over the exact string | vendored `generateHardwareSignatureWithAssertion` | `DeviceBoundApi.post` |
| **Biometric key** (P2) | `KeyGenParameterSpec`: `setUserAuthenticationRequired(true)`, `setUserAuthenticationParameters(0, AUTH_BIOMETRIC_STRONG)`, `setInvalidatedByBiometricEnrollment(true)`, `setAttestationChallenge(linkingChallenge)`; verify `isUserAuthenticationRequirementEnforcedBySecureHardware`; StrongBox preferred, TEE fallback | Secure Enclave key with `SecAccessControl` `.privateKeyUsage + .biometryCurrentSet` (invalidates on enrolment change); attestation: **no equivalent for arbitrary keys** - open question in AP-482 | `react-native-biometrics` uses RSA-2048 and no attestation: **does not meet P2**; needs a native module | `BiometricBindingChannel.kt` |
| Prompt-and-sign in one call | `BiometricPrompt` with `CryptoObject(Signature)`, `BIOMETRIC_STRONG` only | `LAContext` bound to the key; the signature call triggers the prompt | native module | `BiometricBindingChannel.signChallenge` |
| **Passkeys** (P5) | `androidx.credentials` Credential Manager; request/response JSON passed through as strings; needs a `FragmentActivity` | `ASAuthorizationPlatformPublicKeyCredentialProvider`; hand the server JSON through | `react-native-passkey` or native; check it does not re-serialise the options | `PasskeyChannel.kt` |
| **Integrity token** (P7) | Play Integrity **standard** request: `prepareIntegrityToken(cloudProjectNumber)` once, `request(requestHash = challenge)` per call; token opaque; `com.google.android.play:integrity` | App Attest assertion (`generateAssertion`) over the request; DOA validates via `ValidateIntegrityIos` with the signature | vendored `prepareIntegrityToken` / `requestIntegrityToken` | `IntegrityChannel.kt` |
| **Secure store** (P4) | Own store: per-write AES-256-GCM key wrapped by a decrypt-only RSA-4096 keystore key (TEE); slot as AAD; `AtomicFile` in `noBackupFilesDir`; **never** delete on read failure | Keychain item `kSecAttrAccessibleWhenUnlockedThisDeviceOnly`, no iCloud sync (`kSecAttrSynchronizable = false`); AES-GCM under a Secure Enclave key if a wrap is wanted | native module or `react-native-keychain` with `accessible: WHEN_UNLOCKED_THIS_DEVICE_ONLY` - verify it does not wipe on error | `SecureStoreChannel.kt` + `core/secure_store.dart` |
| Backups excluded | `android:allowBackup="false"` and the no-backup dir | `ThisDeviceOnly` accessibility excludes the item from backups | as native | manifest |
| **Health-ID hand-off** (4.6) | PKCE/state/nonce from `SecureRandom`; `ACTION_VIEW` + `CATEGORY_BROWSABLE`; callback via verified App Link (`assetlinks.json` on the callback domain); match scheme/host/port/path | `ASWebAuthenticationSession` with a Universal Link callback (`apple-app-site-association`); `SecRandomCopyBytes` | `react-native-app-auth` or the RN example's broker code; check PKCE and nonce | `HealthIdChannel.kt` + `core/health_id.dart` |
| **Screen capture blocked** | `WindowManager.LayoutParams.FLAG_SECURE` on the activity | no API to block screenshots; hide content on `UIApplication.userDidTakeScreenshotNotification` and blur in the app switcher (`sceneWillResignActive`) | as native | `MainActivity.kt` |
| Body hidden when not foreground | lifecycle observer -> lock icon | `sceneWillResignActive` -> cover view | `AppState` | `CustomerScreen` |
| Monotonic clock for the session | `SystemClock.elapsedRealtime` / a `Stopwatch` | `ProcessInfo.systemUptime` / `DispatchTime` | `performance.now()` is not monotonic across sleeps on all engines - use a native clock | `Stopwatch` |
| CSPRNG | `SecureRandom` | `SecRandomCopyBytes` | never `Math.random`; native | `Random.secure()` + `SecureRandom` |
| Compile-time config (6) | `BuildConfig` fields / manifest placeholders | `Info.plist` from `xcconfig` | `react-native-config` **at build time only** | `--dart-define-from-file` |
| Debug-only affordances (P10) | `BuildConfig.DEBUG` guard and a separate source set | `#if DEBUG` | `__DEV__` **is not enough** - it is a runtime flag; strip the module at bundle time | `kDebugMode` (const-folded) |
| Release hardening | R8 on; keep rules only for reflective libraries (`androidx.credentials`) | bitcode/strip as default | Hermes + minify; ensure no `console.log` of bodies | proguard rules; `--obfuscate` for Dart pending |

## Device binding, per platform

DOA branches on the `deviceOs` of every signed request, and the two branches are not symmetric. An
implementation that assumes Android's shape will send fields iOS cannot produce.

| | Android | iOS |
|---|---|---|
| Device key | KeyStore EC P-256, `setAttestationChallenge` | `DCAppAttestService.generateKey` |
| Key proof | attestation certificate chain | `attestKey` object + the key id in `iosHardwareKey` |
| Request signature | `SHA256withECDSA`, raw | `generateAssertion`, CBOR, base64 |
| Integrity per request | Play Integrity token over the challenge | the assertion itself; DOA reads it from the envelope |
| Biometric key | KeyStore, attested, `setInvalidatedByBiometricEnrollment` | Secure Enclave, `.biometryCurrentSet`, `.privateKeyUsage`; no attestation exists |
| Biometric public key | SubjectPublicKeyInfo | SubjectPublicKeyInfo, assembled from the raw X9.63 point |
| Biometric signature | DER | DER, from `.ecdsaSignatureMessageX962SHA256` |

## Messages (section 3.5)

| Requirement | Android / Kotlin | iOS / Swift | React Native | Flutter |
|---|---|---|---|---|
| Cancelled prompt is info, not error | `GetCredentialCancellationException` / `CreateCredentialCancellationException`; `BiometricPrompt` codes 5, 10, 13 | `ASAuthorizationError.canceled`; `LAError.userCancel` / `.systemCancel` / `.appCancel` | The same native codes, surfaced by the bridge you use (check each library's mapping) | `PlatformException` codes from the channels: `passkey_cancelled`, `biometric_error_{5,10,13}`, `CANCELLED` |
| No answer vs rejected | `IOException` vs an HTTP status | `URLError` vs an HTTP status | fetch rejection vs a response | `DioException` without `response` vs with one |
| Field errors | `TextInputLayout.error` | `.textFieldStyle` + a red caption | your form library's `error` | `InputDecoration.errorText` |
| Snackbar | `Snackbar` | a bottom toast view (no system snackbar) | `Snackbar` from the component library | `ScaffoldMessenger` |

## Traps already found (do not rediscover)

- **Passkey origin is enforced by the platform, not by DOA.** DOA takes the origin from the client's
  own assertion. Android needs `assetlinks.json` with the SHA-256 of *every* certificate that signs a
  build a tester receives: your upload/debug key, the Play app-signing key, and the internal-app-sharing
  key - three certificates, and the third is the one nobody looks up. iOS: the AASA file with the team +
  bundle id.
- **Emulators cannot register** against a tenant that rejects `Software` attestation (which every real
  tenant should). Simulators the same for App Attest.
- **Play Integrity `ValidateAppIntegrity` requires `PLAY_RECOGNIZED`** - sideloaded test builds fail it.
  Turn it off on a test tenant, never on production.
- **A biometric prompt can stay open for minutes.** Request the integrity token *after* the prompt, or a
  server freshness check, once the backend has it, rejects it.
- **A secure store that deletes on read failure turns a keystore hiccup into a silent fresh install.**
  flutter_secure_storage defaults to that (`resetOnError`); its RSA wrap is fixed at 2048. Both are why
  the Flutter example has its own store.
- **`kDebugMode`/`BuildConfig.DEBUG` only strip code when the compiler can fold the constant.** Verify
  by searching the release artefact for a debug-only string.
- **Bash heredocs with apostrophes break in some CI shells** - trivial, but it cost an hour.
- **StrongBox does not offer RSA-4096** - the storage wrapping key lives in the TEE; that is correct.
- **`setAttestationChallenge` on the biometric key with StrongBox** is specified to work but untested on
  a device at the time of writing (reading it is planned on the backend); the TEE fallback exists.
