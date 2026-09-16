# doa-examples
Repository containing integration examples for DOA, azuma's Device Binding API: accounts that are
bound to the phone's hardware keys, so a session can only be opened from the device it was
registered on.

## flutter-device-binding
A customer-facing Android and iOS app on the Device Binding API, built towards BSI TR-03161-1:
email + password, passkeys and Health-ID sign-in with mandatory biometrics and ten-minute sessions;
account transfer from a previous identity provider; and a "phone key" journey that needs no password
at all. Android KeyStore attestation and Play Integrity on Android, App Attest on iOS.

The example is exported from azuma's monorepo; its `docs/spec/conformance-checklist.md` records the
honest state against the guideline, open items included.

## ...
More coming soon.
