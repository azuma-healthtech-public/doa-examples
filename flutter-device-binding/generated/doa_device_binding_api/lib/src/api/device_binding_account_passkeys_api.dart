//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'dart:async';

// ignore: unused_import
import 'dart:convert';
import 'package:doa_device_binding_api/src/deserialize.dart';
import 'package:dio/dio.dart';

import 'package:doa_device_binding_api/src/model/device_binding_passkeys_link_options_response.dart';
import 'package:doa_device_binding_api/src/model/device_binding_passkeys_registration_options_request.dart';
import 'package:doa_device_binding_api/src/model/device_binding_passkeys_registration_options_response.dart';
import 'package:doa_device_binding_api/src/model/device_binding_passkeys_registration_verify_request.dart';
import 'package:doa_device_binding_api/src/model/device_binding_passkeys_registration_verify_response.dart';
import 'package:doa_device_binding_api/src/model/device_bound_request.dart';
import 'package:doa_device_binding_api/src/model/success_response.dart';

class DeviceBindingAccountPasskeysApi {

  final Dio _dio;

  const DeviceBindingAccountPasskeysApi(this._dio);

  /// Link passkey to account - Generate options.
  /// 
  ///
  /// Parameters:
  /// * [applicationId] - ID of the application.
  /// * [deviceBoundRequest] - Request payload. (Payload: <a href=\"#model-DeviceBindingPasskeysLinkOptionsRequest\">DeviceBindingPasskeysLinkOptionsRequest</a>).
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [DeviceBindingPasskeysLinkOptionsResponse] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<DeviceBindingPasskeysLinkOptionsResponse>> deviceBindingAccountLinkAccountPasskeysGenOptions({ 
    required String applicationId,
    DeviceBoundRequest? deviceBoundRequest,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/deviceBinding/account/v1/mobile/{applicationId}/link/passkeys/generate-options'.replaceAll('{' r'applicationId' '}', applicationId.toString());
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
_bodyData=jsonEncode(deviceBoundRequest);
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

    DeviceBindingPasskeysLinkOptionsResponse? _responseData;

    try {
final rawData = _response.data;
_responseData = rawData == null ? null : deserialize<DeviceBindingPasskeysLinkOptionsResponse, DeviceBindingPasskeysLinkOptionsResponse>(rawData, 'DeviceBindingPasskeysLinkOptionsResponse', growable: true);
    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<DeviceBindingPasskeysLinkOptionsResponse>(
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

  /// Link passkey to account - Verify.
  /// 
  ///
  /// Parameters:
  /// * [applicationId] - ID of the application.
  /// * [deviceBoundRequest] - Request payload. (Payload: <a href=\"#model-DeviceBindingPasskeysLinkVerifyRequest\">DeviceBindingPasskeysLinkVerifyRequest</a>).
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [SuccessResponse] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<SuccessResponse>> deviceBindingAccountLinkAccountPasskeysVerify({ 
    required String applicationId,
    DeviceBoundRequest? deviceBoundRequest,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/deviceBinding/account/v1/mobile/{applicationId}/link/passkeys/verify'.replaceAll('{' r'applicationId' '}', applicationId.toString());
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
_bodyData=jsonEncode(deviceBoundRequest);
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

    SuccessResponse? _responseData;

    try {
final rawData = _response.data;
_responseData = rawData == null ? null : deserialize<SuccessResponse, SuccessResponse>(rawData, 'SuccessResponse', growable: true);
    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<SuccessResponse>(
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

  /// Register account via passkey - Generate options.
  /// 
  ///
  /// Parameters:
  /// * [applicationId] - ID of the application.
  /// * [deviceBindingPasskeysRegistrationOptionsRequest] - Request payload.
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [DeviceBindingPasskeysRegistrationOptionsResponse] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<DeviceBindingPasskeysRegistrationOptionsResponse>> deviceBindingAccountRegisterAccountPasskeysGenOptions({ 
    required String applicationId,
    DeviceBindingPasskeysRegistrationOptionsRequest? deviceBindingPasskeysRegistrationOptionsRequest,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/deviceBinding/account/v1/mobile/{applicationId}/register/passkeys/generate-options'.replaceAll('{' r'applicationId' '}', applicationId.toString());
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
_bodyData=jsonEncode(deviceBindingPasskeysRegistrationOptionsRequest);
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

    DeviceBindingPasskeysRegistrationOptionsResponse? _responseData;

    try {
final rawData = _response.data;
_responseData = rawData == null ? null : deserialize<DeviceBindingPasskeysRegistrationOptionsResponse, DeviceBindingPasskeysRegistrationOptionsResponse>(rawData, 'DeviceBindingPasskeysRegistrationOptionsResponse', growable: true);
    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<DeviceBindingPasskeysRegistrationOptionsResponse>(
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

  /// Register account via passkey - Verify.
  /// 
  ///
  /// Parameters:
  /// * [applicationId] - ID of the application.
  /// * [deviceBindingPasskeysRegistrationVerifyRequest] - Request payload.
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [DeviceBindingPasskeysRegistrationVerifyResponse] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<DeviceBindingPasskeysRegistrationVerifyResponse>> deviceBindingAccountRegisterAccountPasskeysVerify({ 
    required String applicationId,
    DeviceBindingPasskeysRegistrationVerifyRequest? deviceBindingPasskeysRegistrationVerifyRequest,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/deviceBinding/account/v1/mobile/{applicationId}/register/passkeys/verify'.replaceAll('{' r'applicationId' '}', applicationId.toString());
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
_bodyData=jsonEncode(deviceBindingPasskeysRegistrationVerifyRequest);
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

    DeviceBindingPasskeysRegistrationVerifyResponse? _responseData;

    try {
final rawData = _response.data;
_responseData = rawData == null ? null : deserialize<DeviceBindingPasskeysRegistrationVerifyResponse, DeviceBindingPasskeysRegistrationVerifyResponse>(rawData, 'DeviceBindingPasskeysRegistrationVerifyResponse', growable: true);
    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<DeviceBindingPasskeysRegistrationVerifyResponse>(
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

  /// Unlink a passkey.
  /// 
  ///
  /// Parameters:
  /// * [applicationId] - ID of the application.
  /// * [deviceBoundRequest] - Request payload. (Payload: <a href=\"#model-DeviceBindingPasskeysUnlinkRequest\">DeviceBindingPasskeysUnlinkRequest</a>).
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [SuccessResponse] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<SuccessResponse>> deviceBindingAccountUnlinkAccountPasskey({ 
    required String applicationId,
    DeviceBoundRequest? deviceBoundRequest,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/deviceBinding/account/v1/mobile/{applicationId}/unlink/passkeys'.replaceAll('{' r'applicationId' '}', applicationId.toString());
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
_bodyData=jsonEncode(deviceBoundRequest);
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

    SuccessResponse? _responseData;

    try {
final rawData = _response.data;
_responseData = rawData == null ? null : deserialize<SuccessResponse, SuccessResponse>(rawData, 'SuccessResponse', growable: true);
    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<SuccessResponse>(
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
