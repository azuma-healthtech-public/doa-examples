# Core

The part of this example an integrator takes: the DOA Device Binding contract and the platform
capabilities it needs. No widgets, no session policy, no opinion about which methods an account
offers. Everything above this folder (`lib/src/customer/`) is one customer's policy on top of it.

| Dart | Kotlin | Provides |
|---|---|---|
| `device_binding.dart` | `DeviceBindingChannel.kt` | The device key: generated in the AndroidKeyStore with a server challenge as attestation challenge; exports the attestation chain; signs request payloads |
| `biometric_binding.dart` | `BiometricBindingChannel.kt` | A biometric-gated key (`BIOMETRIC_STRONG`, per use, invalidated on enrolment change) with attestation; `BiometricPrompt` holding the `Signature` so prompt and sign are one call |
| `passkey_manager.dart` | `PasskeyChannel.kt` | Credential Manager create / get, WebAuthn JSON passed through unparsed |
| `play_integrity.dart` | `IntegrityChannel.kt` | Play Integrity standard requests over a server challenge |
| `secure_store.dart` | `SecureStoreChannel.kt` | String values sealed with AES-256-GCM under an RSA-4096 keystore key; unreadable data is reported, never deleted |
| `health_id.dart` | `HealthIdChannel.kt` | The Health-ID broker round trip: PKCE, browser hand-off, callback validation, token exchange, nonce check |
| `device_bound_api.dart` | - | URL shape and the signed `{payload, signature, deviceOs}` envelope; `authorize` hook between signing and sending |
| `platform_channel.dart` | - | Timeouts for every channel call |

Rules this folder keeps:

- **Signed bytes are sent bytes.** The payload is JSON-encoded once, signed, and sent as that string.
  Passkey options and responses cross the channel as the server produced them.
- **Every challenge comes from the server** and is used for exactly one attestation, integrity
  token or signature. Nothing here caches or reuses one.
- **Keys never leave the hardware.** The Dart side only ever sees public keys, attestation chains
  and signatures. Customer keys (`customer.*` aliases) are never overwritten.
- **Fail closed.** A channel that cannot answer throws; nothing degrades to a software key, a
  missing token or an empty store.
- **No logging.** Bodies carry credentials and provider tokens.

`core.dart` re-exports the lot. `docs/architecture.md` explains why each channel is custom rather than a
pub.dev package.
