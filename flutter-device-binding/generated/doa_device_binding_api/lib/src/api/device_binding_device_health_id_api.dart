//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'dart:async';

// ignore: unused_import
import 'dart:convert';
import 'package:doa_device_binding_api/src/deserialize.dart';
import 'package:dio/dio.dart';

import 'package:doa_device_binding_api/src/model/device_binding_register_additional_device_health_id_request.dart';
import 'package:doa_device_binding_api/src/model/login_response.dart';

class DeviceBindingDeviceHealthIDApi {

  final Dio _dio;

  const DeviceBindingDeviceHealthIDApi(this._dio);

  /// Register additional device via healthId.
  /// 
  ///
  /// Parameters:
  /// * [applicationId] - ID of the application.
  /// * [deviceBindingRegisterAdditionalDeviceHealthIdRequest] - Request payload.
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [LoginResponse] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<LoginResponse>> deviceBindingDeviceRegisterAdditionalViaHealthId({ 
    required String applicationId,
    DeviceBindingRegisterAdditionalDeviceHealthIdRequest? deviceBindingRegisterAdditionalDeviceHealthIdRequest,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/deviceBinding/device/v1/mobile/{applicationId}/register/healthId'.replaceAll('{' r'applicationId' '}', applicationId.toString());
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
_bodyData=jsonEncode(deviceBindingRegisterAdditionalDeviceHealthIdRequest);
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

    LoginResponse? _responseData;

    try {
final rawData = _response.data;
_responseData = rawData == null ? null : deserialize<LoginResponse, LoginResponse>(rawData, 'LoginResponse', growable: true);
    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<LoginResponse>(
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
