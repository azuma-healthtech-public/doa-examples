package com.doa.example.devicebinding.flutter

import android.content.Context
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.security.keystore.KeyGenParameterSpec
import android.security.keystore.KeyInfo
import android.security.keystore.KeyProperties
import android.util.AtomicFile
import android.util.Base64
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.json.JSONObject
import java.io.File
import java.io.FileNotFoundException
import java.security.KeyFactory
import java.security.KeyPairGenerator
import java.security.KeyStore
import java.security.PrivateKey
import java.security.PublicKey
import java.security.SecureRandom
import java.security.spec.MGF1ParameterSpec
import java.security.spec.X509EncodedKeySpec
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors
import javax.crypto.Cipher
import javax.crypto.spec.GCMParameterSpec
import javax.crypto.spec.OAEPParameterSpec
import javax.crypto.spec.PSource
import javax.crypto.spec.SecretKeySpec

/**
 * Encrypted key-value store for the customer journey (BSI TR-03161-1 O.Data_2,
 * O.Cryp_5). It replaces flutter_secure_storage there: that plugin wraps its
 * data key with a 2048-bit RSA key and offers no way to enlarge it, below the
 * 3000 bits TR-02102-1 asks of new systems.
 *
 * Every write seals the value with a fresh AES-256-GCM key, and wraps that key
 * with RSA-4096 OAEP (SHA-256) under a non-exportable, decrypt-only
 * AndroidKeyStore key. The slot name is bound in as associated data, so a blob
 * cannot be moved to another slot. Files live in `noBackupFilesDir` and are
 * written through [AtomicFile], so an interrupted write leaves the old value.
 *
 * MGF1 inside OAEP uses SHA-256 where the keystore allows it (API 34+,
 * `setMgf1Digests`) and SHA-1 below that, where Keymaster supports nothing
 * else. The digest used is recorded per blob and confirmed by a round trip
 * against the key, so an OS upgrade never strands existing data.
 *
 * Unlike the plugin, a value that cannot be read is reported, never deleted:
 * the customer controller's storage gate relies on seeing that failure.
 *
 * All work runs on one background thread. Generating an RSA-4096 key inside the
 * TEE takes seconds on some devices and must not block the platform thread.
 */
class SecureStoreChannel(context: Context) {
    private val directory = File(context.applicationContext.noBackupFilesDir, DIRECTORY)
    private val main = Handler(Looper.getMainLooper())
    private val random = SecureRandom()
    private val keystore: KeyStore by lazy { KeyStore.getInstance(KEYSTORE).apply { load(null) } }

    /** Worker-thread only. Reset whenever a new wrapping key is generated. */
    private var mgf1: MGF1ParameterSpec? = null

    fun register(messenger: BinaryMessenger): MethodChannel {
        val channel = MethodChannel(messenger, CHANNEL)
        channel.setMethodCallHandler { call, result -> handle(call, result) }
        // On a fresh install the wrapping key is generated now, off the UI path,
        // so the first registration does not wait for it. A failure here
        // surfaces again, and is reported, on the first write.
        worker.execute { runCatching { wrappingKey() } }
        return channel
    }

    private fun handle(call: MethodCall, result: MethodChannel.Result) {
        if (call.method !in METHODS) {
            result.notImplemented()
            return
        }
        worker.execute {
            val outcome = runCatching { perform(call) }
            main.post {
                outcome.fold(
                    onSuccess = { result.success(it) },
                    // The exception type only; crypto-stack messages are not forwarded.
                    onFailure = { result.error(ERROR_CODE, it.javaClass.simpleName, null) },
                )
            }
        }
    }

    private fun perform(call: MethodCall): String? {
        val file = slot(call.arg("key"))
        when (call.method) {
            "read" -> return read(file)
            "write" -> write(file, call.arg("value"))
            "delete" -> AtomicFile(file).delete()
        }
        return null
    }

    private fun slot(name: String): File {
        require(SLOT_NAME.matches(name)) { "Invalid key" }
        return File(directory, name)
    }

    private fun read(file: File): String? {
        val bytes = try {
            AtomicFile(file).readFully()
        } catch (_: FileNotFoundException) {
            return null
        }
        val blob = JSONObject(String(bytes, Charsets.UTF_8))
        check(blob.getInt("v") == FORMAT_VERSION) { "Unsupported store format" }
        // Reading never generates a key: a blob whose key is gone is unreadable.
        val privateKey = keystore.getKey(KEY_ALIAS, null) as? PrivateKey
            ?: throw IllegalStateException("Storage wrapping key is missing")
        val rawKey = Cipher.getInstance(RSA_TRANSFORMATION).run {
            init(Cipher.DECRYPT_MODE, privateKey, oaep(mgf1Named(blob.getString("mgf1"))))
            doFinal(decode(blob.getString("key")))
        }
        try {
            val aes = Cipher.getInstance(AES_TRANSFORMATION)
            aes.init(
                Cipher.DECRYPT_MODE,
                SecretKeySpec(rawKey, "AES"),
                GCMParameterSpec(GCM_TAG_BITS, decode(blob.getString("iv"))),
            )
            aes.updateAAD(associatedData(file))
            return String(aes.doFinal(decode(blob.getString("ct"))), Charsets.UTF_8)
        } finally {
            rawKey.fill(0)
        }
    }

    private fun write(file: File, value: String) {
        val spec = supportedMgf1()
        val rawKey = ByteArray(AES_KEY_BYTES).also(random::nextBytes)
        try {
            val iv = ByteArray(GCM_IV_BYTES).also(random::nextBytes)
            val aes = Cipher.getInstance(AES_TRANSFORMATION)
            aes.init(Cipher.ENCRYPT_MODE, SecretKeySpec(rawKey, "AES"), GCMParameterSpec(GCM_TAG_BITS, iv))
            aes.updateAAD(associatedData(file))
            val ciphertext = aes.doFinal(value.toByteArray(Charsets.UTF_8))
            val wrapped = Cipher.getInstance(RSA_TRANSFORMATION).run {
                init(Cipher.ENCRYPT_MODE, publicKey(), oaep(spec))
                doFinal(rawKey)
            }
            val blob = JSONObject()
                .put("v", FORMAT_VERSION)
                .put("mgf1", spec.digestAlgorithm)
                .put("key", encode(wrapped))
                .put("iv", encode(iv))
                .put("ct", encode(ciphertext))

            directory.mkdirs()
            val target = AtomicFile(file)
            val out = target.startWrite()
            try {
                out.write(blob.toString().toByteArray(Charsets.UTF_8))
                target.finishWrite(out)
            } catch (e: Exception) {
                target.failWrite(out)
                throw e
            }
        } finally {
            rawKey.fill(0)
        }
    }

    /** The decrypt-only RSA-4096 key, generated on first use. */
    private fun wrappingKey(): PrivateKey =
        keystore.getKey(KEY_ALIAS, null) as? PrivateKey ?: generateWrappingKey()

    private fun generateWrappingKey(): PrivateKey {
        val builder = KeyGenParameterSpec.Builder(KEY_ALIAS, KeyProperties.PURPOSE_DECRYPT)
            .setKeySize(RSA_KEY_BITS)
            .setDigests(KeyProperties.DIGEST_SHA256)
            .setBlockModes(KeyProperties.BLOCK_MODE_ECB)
            .setEncryptionPaddings(KeyProperties.ENCRYPTION_PADDING_RSA_OAEP)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
            builder.setMgf1Digests(KeyProperties.DIGEST_SHA256)
        }
        // StrongBox only offers RSA-2048, so this key always lives in the TEE.
        val pair = KeyPairGenerator.getInstance(KeyProperties.KEY_ALGORITHM_RSA, KEYSTORE)
            .apply { initialize(builder.build()) }
            .generateKeyPair()
        if (!isHardwareBacked(pair.private)) {
            keystore.deleteEntry(KEY_ALIAS)
            throw IllegalStateException("Hardware-backed storage key required")
        }
        mgf1 = null
        return pair.private
    }

    /**
     * The public half as a plain software key. Wrapping needs no secret, so it
     * runs in the regular provider with explicit OAEP parameters, which keeps
     * both sides of the round trip agreeing on the MGF1 digest.
     */
    private fun publicKey(): PublicKey {
        wrappingKey()
        val encoded = keystore.getCertificate(KEY_ALIAS).publicKey.encoded
        return KeyFactory.getInstance(KeyProperties.KEY_ALGORITHM_RSA).generatePublic(X509EncodedKeySpec(encoded))
    }

    private fun supportedMgf1(): MGF1ParameterSpec {
        mgf1?.let { return it }
        val sha256 = Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE &&
            roundTrips(MGF1ParameterSpec.SHA256)
        return (if (sha256) MGF1ParameterSpec.SHA256 else MGF1ParameterSpec.SHA1).also { mgf1 = it }
    }

    /** Whether the keystore key accepts [spec]; a key made before API 34 does not accept SHA-256. */
    private fun roundTrips(spec: MGF1ParameterSpec): Boolean = try {
        val probe = ByteArray(AES_KEY_BYTES).also(random::nextBytes)
        val wrapped = Cipher.getInstance(RSA_TRANSFORMATION).run {
            init(Cipher.ENCRYPT_MODE, publicKey(), oaep(spec))
            doFinal(probe)
        }
        val unwrapped = Cipher.getInstance(RSA_TRANSFORMATION).run {
            init(Cipher.DECRYPT_MODE, wrappingKey(), oaep(spec))
            doFinal(wrapped)
        }
        unwrapped.contentEquals(probe)
    } catch (_: Exception) {
        false
    }

    private fun isHardwareBacked(key: PrivateKey): Boolean {
        val info = KeyFactory.getInstance(key.algorithm, KEYSTORE).getKeySpec(key, KeyInfo::class.java)
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            info.securityLevel == KeyProperties.SECURITY_LEVEL_TRUSTED_ENVIRONMENT ||
                info.securityLevel == KeyProperties.SECURITY_LEVEL_STRONGBOX ||
                info.securityLevel == KeyProperties.SECURITY_LEVEL_UNKNOWN_SECURE
        } else {
            @Suppress("DEPRECATION")
            info.isInsideSecureHardware
        }
    }

    private fun oaep(mgf1: MGF1ParameterSpec) =
        OAEPParameterSpec("SHA-256", "MGF1", mgf1, PSource.PSpecified.DEFAULT)

    private fun mgf1Named(name: String): MGF1ParameterSpec = when (name) {
        MGF1ParameterSpec.SHA256.digestAlgorithm -> MGF1ParameterSpec.SHA256
        MGF1ParameterSpec.SHA1.digestAlgorithm -> MGF1ParameterSpec.SHA1
        else -> throw IllegalStateException("Unsupported MGF1 digest")
    }

    private fun associatedData(file: File) = "$FORMAT_TAG:${file.name}".toByteArray(Charsets.UTF_8)

    private fun encode(bytes: ByteArray) = Base64.encodeToString(bytes, Base64.NO_WRAP)

    private fun decode(text: String) = Base64.decode(text, Base64.NO_WRAP)

    companion object {
        /** Must match `NativeSecureStore._channel` in `lib/src/customer/customer_storage.dart`. */
        const val CHANNEL = "com.doa.example.devicebinding.flutter/secure_store"

        private const val ERROR_CODE = "secure_store_error"
        private const val KEYSTORE = "AndroidKeyStore"
        private const val KEY_ALIAS = "customer.storage.wrap.rsa4096"
        private const val RSA_KEY_BITS = 4096
        private const val RSA_TRANSFORMATION = "RSA/ECB/OAEPPadding"
        private const val AES_TRANSFORMATION = "AES/GCM/NoPadding"
        private const val AES_KEY_BYTES = 32
        private const val GCM_IV_BYTES = 12
        private const val GCM_TAG_BITS = 128
        private const val FORMAT_VERSION = 1
        private const val FORMAT_TAG = "doa.customer-store.v1"
        private const val DIRECTORY = "customer_store"
        private val METHODS = setOf("read", "write", "delete")
        private val SLOT_NAME = Regex("[A-Za-z0-9][A-Za-z0-9._-]{0,63}")

        /** Process-wide, so every channel instance shares one serial queue. */
        private val worker: ExecutorService = Executors.newSingleThreadExecutor()
    }
}
