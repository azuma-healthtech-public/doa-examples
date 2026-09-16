import 'package:doa_device_binding_api/src/model/challenge_response.dart';
import 'package:doa_device_binding_api/src/model/change_password_logged_in_user_request.dart';
import 'package:doa_device_binding_api/src/model/change_password_request.dart';
import 'package:doa_device_binding_api/src/model/confirm_account_email_request.dart';
import 'package:doa_device_binding_api/src/model/confirm_email_recovery_request.dart';
import 'package:doa_device_binding_api/src/model/confirm_email_recovery_response.dart';
import 'package:doa_device_binding_api/src/model/dak_primary_prepare_rotation_request.dart';
import 'package:doa_device_binding_api/src/model/dak_primary_prepare_rotation_response.dart';
import 'package:doa_device_binding_api/src/model/dak_primary_rotate_request.dart';
import 'package:doa_device_binding_api/src/model/device_attestation_dto.dart';
import 'package:doa_device_binding_api/src/model/device_binding_audit_log_auth_event_response.dart';
import 'package:doa_device_binding_api/src/model/device_binding_audit_log_auth_events_page_response.dart';
import 'package:doa_device_binding_api/src/model/device_binding_audit_log_auth_events_request.dart';
import 'package:doa_device_binding_api/src/model/device_binding_biometrics_link_request.dart';
import 'package:doa_device_binding_api/src/model/device_binding_biometrics_login_request.dart';
import 'package:doa_device_binding_api/src/model/device_binding_biometrics_unlink_request.dart';
import 'package:doa_device_binding_api/src/model/device_binding_link_health_id_account_request.dart';
import 'package:doa_device_binding_api/src/model/device_binding_passkeys_link_options_request.dart';
import 'package:doa_device_binding_api/src/model/device_binding_passkeys_link_options_response.dart';
import 'package:doa_device_binding_api/src/model/device_binding_passkeys_link_verify_request.dart';
import 'package:doa_device_binding_api/src/model/device_binding_passkeys_login_options_request.dart';
import 'package:doa_device_binding_api/src/model/device_binding_passkeys_login_options_response.dart';
import 'package:doa_device_binding_api/src/model/device_binding_passkeys_login_verify_request.dart';
import 'package:doa_device_binding_api/src/model/device_binding_passkeys_registration_options_request.dart';
import 'package:doa_device_binding_api/src/model/device_binding_passkeys_registration_options_response.dart';
import 'package:doa_device_binding_api/src/model/device_binding_passkeys_registration_verify_request.dart';
import 'package:doa_device_binding_api/src/model/device_binding_passkeys_registration_verify_response.dart';
import 'package:doa_device_binding_api/src/model/device_binding_passkeys_unlink_request.dart';
import 'package:doa_device_binding_api/src/model/device_binding_refresh_request.dart';
import 'package:doa_device_binding_api/src/model/device_binding_register_additional_device_email_request.dart';
import 'package:doa_device_binding_api/src/model/device_binding_register_additional_device_health_id_request.dart';
import 'package:doa_device_binding_api/src/model/device_binding_register_additional_device_username_request.dart';
import 'package:doa_device_binding_api/src/model/device_binding_register_device_passkeys_options_request.dart';
import 'package:doa_device_binding_api/src/model/device_binding_register_device_passkeys_options_response.dart';
import 'package:doa_device_binding_api/src/model/device_binding_register_device_passkeys_verify_request.dart';
import 'package:doa_device_binding_api/src/model/device_binding_register_device_passkeys_verify_response.dart';
import 'package:doa_device_binding_api/src/model/device_binding_register_email_account_request.dart';
import 'package:doa_device_binding_api/src/model/device_binding_register_email_account_response.dart';
import 'package:doa_device_binding_api/src/model/device_binding_register_health_id_account_request.dart';
import 'package:doa_device_binding_api/src/model/device_binding_register_health_id_account_response.dart';
import 'package:doa_device_binding_api/src/model/device_binding_register_oidc_account_request.dart';
import 'package:doa_device_binding_api/src/model/device_binding_register_oidc_account_response.dart';
import 'package:doa_device_binding_api/src/model/device_binding_register_username_account_request.dart';
import 'package:doa_device_binding_api/src/model/device_binding_register_username_account_response.dart';
import 'package:doa_device_binding_api/src/model/device_binding_un_link_health_id_account_request.dart';
import 'package:doa_device_binding_api/src/model/device_bound_integrity_verification_data.dart';
import 'package:doa_device_binding_api/src/model/device_bound_request.dart';
import 'package:doa_device_binding_api/src/model/device_bound_request_payload.dart';
import 'package:doa_device_binding_api/src/model/error_dto.dart';
import 'package:doa_device_binding_api/src/model/global_logout_user_request.dart';
import 'package:doa_device_binding_api/src/model/initiate_email_recovery_request.dart';
import 'package:doa_device_binding_api/src/model/initiate_email_recovery_response.dart';
import 'package:doa_device_binding_api/src/model/initiate_email_verification_request.dart';
import 'package:doa_device_binding_api/src/model/initiate_email_verification_response.dart';
import 'package:doa_device_binding_api/src/model/introspect_token_request.dart';
import 'package:doa_device_binding_api/src/model/introspect_token_response.dart';
import 'package:doa_device_binding_api/src/model/login_account_request.dart';
import 'package:doa_device_binding_api/src/model/login_email_account_request.dart';
import 'package:doa_device_binding_api/src/model/login_health_id_account_request.dart';
import 'package:doa_device_binding_api/src/model/login_id_account_request.dart';
import 'package:doa_device_binding_api/src/model/login_oidc_account_request.dart';
import 'package:doa_device_binding_api/src/model/login_response.dart';
import 'package:doa_device_binding_api/src/model/login_username_account_request.dart';
import 'package:doa_device_binding_api/src/model/logout_user_request.dart';
import 'package:doa_device_binding_api/src/model/post_login_action.dart';
import 'package:doa_device_binding_api/src/model/refresh_token_request.dart';
import 'package:doa_device_binding_api/src/model/refresh_token_response.dart';
import 'package:doa_device_binding_api/src/model/revoke_token_request.dart';
import 'package:doa_device_binding_api/src/model/success_response.dart';
import 'package:doa_device_binding_api/src/model/token_response.dart';
import 'package:doa_device_binding_api/src/model/user_device_data.dart';
import 'package:doa_device_binding_api/src/model/user_info_biometric_credential_response.dart';
import 'package:doa_device_binding_api/src/model/user_info_linked_authentication_response.dart';
import 'package:doa_device_binding_api/src/model/user_info_passkey_credential_response.dart';
import 'package:doa_device_binding_api/src/model/user_info_request.dart';
import 'package:doa_device_binding_api/src/model/user_info_response.dart';

final _regList = RegExp(r'^List<(.*)>$');
final _regSet = RegExp(r'^Set<(.*)>$');
final _regMap = RegExp(r'^Map<String,(.*)>$');

  ReturnType deserialize<ReturnType, BaseType>(dynamic value, String targetType, {bool growable= true}) {
      switch (targetType) {
        case 'String':
          return '$value' as ReturnType;
        case 'int':
          return (value is int ? value : int.parse('$value')) as ReturnType;
        case 'bool':
          if (value is bool) {
            return value as ReturnType;
          }
          final valueString = '$value'.toLowerCase();
          return (valueString == 'true' || valueString == '1') as ReturnType;
        case 'double':
          return (value is double ? value : double.parse('$value')) as ReturnType;
        case 'AuditLogStatus':
          
          
        case 'AuditLogType':
          
          
        case 'BusinessErrorCodes':
          
          
        case 'ChallengeResponse':
          return ChallengeResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ChangePasswordLoggedInUserRequest':
          return ChangePasswordLoggedInUserRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ChangePasswordRequest':
          return ChangePasswordRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ConfirmAccountEmailRequest':
          return ConfirmAccountEmailRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ConfirmEmailRecoveryRequest':
          return ConfirmEmailRecoveryRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ConfirmEmailRecoveryResponse':
          return ConfirmEmailRecoveryResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DakPrimaryPrepareRotationRequest':
          return DakPrimaryPrepareRotationRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DakPrimaryPrepareRotationResponse':
          return DakPrimaryPrepareRotationResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DakPrimaryRotateRequest':
          return DakPrimaryRotateRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DeviceAttestationDto':
          return DeviceAttestationDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DeviceBindingAuditLogAuthEventResponse':
          return DeviceBindingAuditLogAuthEventResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DeviceBindingAuditLogAuthEventsPageResponse':
          return DeviceBindingAuditLogAuthEventsPageResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DeviceBindingAuditLogAuthEventsRequest':
          return DeviceBindingAuditLogAuthEventsRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DeviceBindingBiometricsLinkRequest':
          return DeviceBindingBiometricsLinkRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DeviceBindingBiometricsLoginRequest':
          return DeviceBindingBiometricsLoginRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DeviceBindingBiometricsUnlinkRequest':
          return DeviceBindingBiometricsUnlinkRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DeviceBindingLinkHealthIdAccountRequest':
          return DeviceBindingLinkHealthIdAccountRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DeviceBindingPasskeysLinkOptionsRequest':
          return DeviceBindingPasskeysLinkOptionsRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DeviceBindingPasskeysLinkOptionsResponse':
          return DeviceBindingPasskeysLinkOptionsResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DeviceBindingPasskeysLinkVerifyRequest':
          return DeviceBindingPasskeysLinkVerifyRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DeviceBindingPasskeysLoginOptionsRequest':
          return DeviceBindingPasskeysLoginOptionsRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DeviceBindingPasskeysLoginOptionsResponse':
          return DeviceBindingPasskeysLoginOptionsResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DeviceBindingPasskeysLoginVerifyRequest':
          return DeviceBindingPasskeysLoginVerifyRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DeviceBindingPasskeysRegistrationOptionsRequest':
          return DeviceBindingPasskeysRegistrationOptionsRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DeviceBindingPasskeysRegistrationOptionsResponse':
          return DeviceBindingPasskeysRegistrationOptionsResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DeviceBindingPasskeysRegistrationVerifyRequest':
          return DeviceBindingPasskeysRegistrationVerifyRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DeviceBindingPasskeysRegistrationVerifyResponse':
          return DeviceBindingPasskeysRegistrationVerifyResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DeviceBindingPasskeysUnlinkRequest':
          return DeviceBindingPasskeysUnlinkRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DeviceBindingRefreshRequest':
          return DeviceBindingRefreshRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DeviceBindingRegisterAdditionalDeviceEmailRequest':
          return DeviceBindingRegisterAdditionalDeviceEmailRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DeviceBindingRegisterAdditionalDeviceHealthIdRequest':
          return DeviceBindingRegisterAdditionalDeviceHealthIdRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DeviceBindingRegisterAdditionalDeviceUsernameRequest':
          return DeviceBindingRegisterAdditionalDeviceUsernameRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DeviceBindingRegisterDevicePasskeysOptionsRequest':
          return DeviceBindingRegisterDevicePasskeysOptionsRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DeviceBindingRegisterDevicePasskeysOptionsResponse':
          return DeviceBindingRegisterDevicePasskeysOptionsResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DeviceBindingRegisterDevicePasskeysVerifyRequest':
          return DeviceBindingRegisterDevicePasskeysVerifyRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DeviceBindingRegisterDevicePasskeysVerifyResponse':
          return DeviceBindingRegisterDevicePasskeysVerifyResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DeviceBindingRegisterEmailAccountRequest':
          return DeviceBindingRegisterEmailAccountRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DeviceBindingRegisterEmailAccountResponse':
          return DeviceBindingRegisterEmailAccountResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DeviceBindingRegisterHealthIdAccountRequest':
          return DeviceBindingRegisterHealthIdAccountRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DeviceBindingRegisterHealthIdAccountResponse':
          return DeviceBindingRegisterHealthIdAccountResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DeviceBindingRegisterOidcAccountRequest':
          return DeviceBindingRegisterOidcAccountRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DeviceBindingRegisterOidcAccountResponse':
          return DeviceBindingRegisterOidcAccountResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DeviceBindingRegisterUsernameAccountRequest':
          return DeviceBindingRegisterUsernameAccountRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DeviceBindingRegisterUsernameAccountResponse':
          return DeviceBindingRegisterUsernameAccountResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DeviceBindingUnLinkHealthIdAccountRequest':
          return DeviceBindingUnLinkHealthIdAccountRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DeviceBoundIntegrityVerificationData':
          return DeviceBoundIntegrityVerificationData.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DeviceBoundRequest':
          return DeviceBoundRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DeviceBoundRequestPayload':
          return DeviceBoundRequestPayload.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ErrorDto':
          return ErrorDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ExternalOidcProvider':
          
          
        case 'GlobalLogoutUserRequest':
          return GlobalLogoutUserRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'InitiateEmailRecoveryRequest':
          return InitiateEmailRecoveryRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'InitiateEmailRecoveryResponse':
          return InitiateEmailRecoveryResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'InitiateEmailVerificationRequest':
          return InitiateEmailVerificationRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'InitiateEmailVerificationResponse':
          return InitiateEmailVerificationResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'IntrospectTokenRequest':
          return IntrospectTokenRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'IntrospectTokenResponse':
          return IntrospectTokenResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'LoginAccountRequest':
          return LoginAccountRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'LoginEmailAccountRequest':
          return LoginEmailAccountRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'LoginHealthIdAccountRequest':
          return LoginHealthIdAccountRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'LoginIdAccountRequest':
          return LoginIdAccountRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'LoginOidcAccountRequest':
          return LoginOidcAccountRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'LoginResponse':
          return LoginResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'LoginUsernameAccountRequest':
          return LoginUsernameAccountRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'LogoutUserRequest':
          return LogoutUserRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'PostLoginAction':
          return PostLoginAction.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'PostLoginActionType':
          
          
        case 'RefreshTokenRequest':
          return RefreshTokenRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'RefreshTokenResponse':
          return RefreshTokenResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'RevokeTokenRequest':
          return RevokeTokenRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'SuccessResponse':
          return SuccessResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'TokenResponse':
          return TokenResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'UserDeviceData':
          return UserDeviceData.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'UserDeviceOs':
          
          
        case 'UserInfoBiometricCredentialResponse':
          return UserInfoBiometricCredentialResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'UserInfoLinkedAuthenticationResponse':
          return UserInfoLinkedAuthenticationResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'UserInfoPasskeyCredentialResponse':
          return UserInfoPasskeyCredentialResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'UserInfoRequest':
          return UserInfoRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'UserInfoResponse':
          return UserInfoResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'UserRegistrationStatus':
          
          
        default:
          RegExpMatch? match;

          if (value is List && (match = _regList.firstMatch(targetType)) != null) {
            targetType = match![1]!; // ignore: parameter_assignments
            return value
              .map<BaseType>((dynamic v) => deserialize<BaseType, BaseType>(v, targetType, growable: growable))
              .toList(growable: growable) as ReturnType;
          }
          if (value is Set && (match = _regSet.firstMatch(targetType)) != null) {
            targetType = match![1]!; // ignore: parameter_assignments
            return value
              .map<BaseType>((dynamic v) => deserialize<BaseType, BaseType>(v, targetType, growable: growable))
              .toSet() as ReturnType;
          }
          if (value is Map && (match = _regMap.firstMatch(targetType)) != null) {
            targetType = match![1]!.trim(); // ignore: parameter_assignments
            return Map<String, BaseType>.fromIterables(
              value.keys as Iterable<String>,
              value.values.map((dynamic v) => deserialize<BaseType, BaseType>(v, targetType, growable: growable)),
            ) as ReturnType;
          }
          break;
    }
    throw Exception('Cannot deserialize');
  }