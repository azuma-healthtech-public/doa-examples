package com.doa.example.devicebinding.flutter

import io.flutter.plugin.common.MethodCall

/** Reads a required, non-null argument off a [MethodCall]. Shared by all three channels. */
internal inline fun <reified T> MethodCall.arg(name: String): T =
    argument<T>(name) ?: throw IllegalArgumentException("Missing argument '$name' for $method")
