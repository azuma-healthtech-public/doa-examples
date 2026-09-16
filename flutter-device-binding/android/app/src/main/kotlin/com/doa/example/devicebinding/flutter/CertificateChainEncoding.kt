package com.doa.example.devicebinding.flutter

import android.util.Base64
import java.security.cert.Certificate

/**
 * The wire encoding DOA expects for an AndroidKeyStore attestation chain in
 * `DeviceAttestationDto.attestation`: each certificate DER-encoded and base64'd,
 * joined with commas, and that string base64'd again. The device key and the
 * biometric key send their chains this way, so the server parses both alike.
 */
internal fun encodeCertificateChain(chain: Array<out Certificate>): String {
    val certificates = chain.joinToString(",") { Base64.encodeToString(it.encoded, Base64.DEFAULT) }
    return Base64.encodeToString(certificates.toByteArray(), Base64.DEFAULT)
}
