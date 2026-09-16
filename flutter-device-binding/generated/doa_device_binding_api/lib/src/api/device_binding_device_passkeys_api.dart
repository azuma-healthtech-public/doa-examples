//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'dart:async';

// ignore: unused_import
import 'dart:convert';
import 'package:doa_device_binding_api/src/deserialize.dart';
import 'package:dio/dio.dart';

import 'package:doa_device_binding_api/src/model/device_binding_register_device_passkeys_options_request.dart';
import 'package:doa_device_binding_api/src/model/device_binding_register_device_passkeys_options_response.dart';
import 'package:doa_device_binding_api/src/model/device_binding_register_device_passkeys_verify_request.dart';
import 'package:doa_device_binding_api/src/model/device_binding_register_device_passkeys_verify_response.dart';

class DeviceBindingDevicePasskeysApi {

  final Dio _dio;

  const DeviceBindingDevicePasskeysApi(this._dio);

  /// Register additional device via passkeys. Generate options API.
  /// 
  ///
  /// Parameters:
  /// * [applicationId] - ID of the application.
  /// * [deviceBindingRegisterDevicePasskeysOptionsRequest] - Request payload.
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [DeviceBindingRegisterDevicePasskeysOptionsResponse] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<DeviceBindingRegisterDevicePasskeysOptionsResponse>> deviceBindingDeviceRegisterViaPasskeysGenOptions({ 
    required String applicationId,
    DeviceBindingRegisterDevicePasskeysOptionsRequest? deviceBindingRegisterDevicePasskeysOptionsRequest,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/deviceBinding/device/v1/mobile/{applicationId}/register/passkeys/generate-options'.replaceAll('{' r'applicationId' '}', applicationId.toString());
    final _options = Options(
      method: r'POST',
      headers: <String, dynamic>{
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[],
        ...?extra,
      },
      contentType: 'application/json',
      validateStatus: validateStatus,
    );

    dynamic _bodyData;

    try {
_bodyData=jsonEncode(deviceBindingRegisterDevicePasskeysOptionsRequest);
    } catch(error, stackTrace) {
      throw DioException(
         requestOptions: _options.compose(
          _dio.options,
          _path,
        ),
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    final _response = await _dio.request<Object>(
      _path,
      data: _bodyData,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    DeviceBindingRegisterDevicePasskeysOptionsResponse? _responseData;

    try {
final rawData = _response.data;
_responseData = rawData == null ? null : deserialize<DeviceBindingRegisterDevicePasskeysOptionsResponse, DeviceBindingRegisterDevicePasskeysOptionsResponse>(rawData, 'DeviceBindingRegisterDevicePasskeysOptionsResponse', growable: true);
    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<DeviceBindingRegisterDevicePasskeysOptionsResponse>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

  /// Register additional device via passkeys. Verify API.
  /// 
  ///
  /// Parameters:
  /// * [applicationId] - ID of the application.
  /// * [deviceBindingRegisterDevicePasskeysVerifyRequest] - Request payload.
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [DeviceBindingRegisterDevicePasskeysVerifyResponse] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<DeviceBindingRegisterDevicePasskeysVerifyResponse>> deviceBindingDeviceRegisterViaPasskeysVerify({ 
    required String applicationId,
    DeviceBindingRegisterDevicePasskeysVerifyRequest? deviceBindingRegisterDevicePasskeysVerifyRequest,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/deviceBinding/device/v1/mobile/{applicationId}/register/passkeys/verify'.replaceAll('{' r'applicationId' '}', applicationId.toString());
    final _options = Options(
      method: r'POST',
      headers: <String, dynamic>{
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[],
        ...?extra,
      },
      contentType: 'application/json',
      validateStatus: validateStatus,
    );

    dynamic _bodyData;

    try {
_bodyData=jsonEncode(deviceBindingRegisterDevicePasskeysVerifyRequest);
    } catch(error, stackTrace) {
      throw DioException(
         requestOptions: _options.compose(
          _dio.options,
          _path,
        ),
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    final _response = await _dio.request<Object>(
      _path,
      data: _bodyData,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    DeviceBindingRegisterDevicePasskeysVerifyResponse? _responseData;

    try {
final rawData = _response.data;
_responseData = rawData == null ? null : deserialize<DeviceBindingRegisterDevicePasskeysVerifyResponse, DeviceBindingRegisterDevicePasskeysVerifyResponse>(rawData, 'DeviceBindingRegisterDevicePasskeysVerifyResponse', growable: true);
    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<DeviceBindingRegisterDevicePasskeysVerifyResponse>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

}
