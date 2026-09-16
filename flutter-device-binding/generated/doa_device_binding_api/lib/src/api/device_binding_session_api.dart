//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'dart:async';

// ignore: unused_import
import 'dart:convert';
import 'package:doa_device_binding_api/src/deserialize.dart';
import 'package:dio/dio.dart';

import 'package:doa_device_binding_api/src/model/device_bound_request.dart';
import 'package:doa_device_binding_api/src/model/introspect_token_response.dart';
import 'package:doa_device_binding_api/src/model/success_response.dart';

class DeviceBindingSessionApi {

  final Dio _dio;

  const DeviceBindingSessionApi(this._dio);

  /// Introspect the given token.
  /// 
  ///
  /// Parameters:
  /// * [applicationId] - ID of the application.
  /// * [deviceBoundRequest] - Request payload. (Payload: <a href=\"#model-IntrospectTokenRequest\">IntrospectTokenRequest</a>).
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [IntrospectTokenResponse] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<IntrospectTokenResponse>> deviceBindingSessionIntrospectToken({ 
    required String applicationId,
    DeviceBoundRequest? deviceBoundRequest,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/deviceBinding/session/v1/mobile/{applicationId}/introspect'.replaceAll('{' r'applicationId' '}', applicationId.toString());
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

    IntrospectTokenResponse? _responseData;

    try {
final rawData = _response.data;
_responseData = rawData == null ? null : deserialize<IntrospectTokenResponse, IntrospectTokenResponse>(rawData, 'IntrospectTokenResponse', growable: true);
    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<IntrospectTokenResponse>(
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

  /// Revoke the given token.
  /// 
  ///
  /// Parameters:
  /// * [applicationId] - ID of the application.
  /// * [deviceBoundRequest] - Request payload. (Payload: <a href=\"#model-RevokeTokenRequest\">RevokeTokenRequest</a>).
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [SuccessResponse] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<SuccessResponse>> deviceBindingSessionRevokeToken({ 
    required String applicationId,
    DeviceBoundRequest? deviceBoundRequest,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/deviceBinding/session/v1/mobile/{applicationId}/revoke'.replaceAll('{' r'applicationId' '}', applicationId.toString());
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
