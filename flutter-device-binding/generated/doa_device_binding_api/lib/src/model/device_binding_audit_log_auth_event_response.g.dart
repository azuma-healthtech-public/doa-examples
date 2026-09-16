// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_binding_audit_log_auth_event_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceBindingAuditLogAuthEventResponse
_$DeviceBindingAuditLogAuthEventResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate('DeviceBindingAuditLogAuthEventResponse', json, (
      $checkedConvert,
    ) {
      final val = DeviceBindingAuditLogAuthEventResponse(
        createdAt: $checkedConvert(
          'createdAt',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
        status: $checkedConvert(
          'status',
          (v) => $enumDecodeNullable(_$AuditLogStatusEnumMap, v),
        ),
        type: $checkedConvert(
          'type',
          (v) => $enumDecodeNullable(_$AuditLogTypeEnumMap, v),
        ),
        executingUserDeviceData: $checkedConvert(
          'executingUserDeviceData',
          (v) => v == null
              ? null
              : UserDeviceData.fromJson(v as Map<String, dynamic>),
        ),
        errorCode: $checkedConvert('errorCode', (v) => v as String?),
        errorData: $checkedConvert('errorData', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$DeviceBindingAuditLogAuthEventResponseToJson(
  DeviceBindingAuditLogAuthEventResponse instance,
) => <String, dynamic>{
  'createdAt': ?instance.createdAt?.toIso8601String(),
  'status': ?_$AuditLogStatusEnumMap[instance.status],
  'type': ?_$AuditLogTypeEnumMap[instance.type],
  'executingUserDeviceData': ?instance.executingUserDeviceData?.toJson(),
  'errorCode': ?instance.errorCode,
  'errorData': ?instance.errorData,
};

const _$AuditLogStatusEnumMap = {
  AuditLogStatus.unknown: 'Unknown',
  AuditLogStatus.error: 'Error',
  AuditLogStatus.success: 'Success',
};

const _$AuditLogTypeEnumMap = {
  AuditLogType.unknown: 'Unknown',
  AuditLogType.accountChangePassword: 'AccountChangePassword',
  AuditLogType.accountConfirmEmailVerification:
      'AccountConfirmEmailVerification',
  AuditLogType.accountInitiateEmailVerification:
      'AccountInitiateEmailVerification',
  AuditLogType.accountRecoveryInitiateViaEmail:
      'AccountRecoveryInitiateViaEmail',
  AuditLogType.accountRecoveryConfirmEmailCode:
      'AccountRecoveryConfirmEmailCode',
  AuditLogType.accountRecoveryChangePassword: 'AccountRecoveryChangePassword',
  AuditLogType.accountRegisterEmail: 'AccountRegisterEmail',
  AuditLogType.accountRegisterHealthId: 'AccountRegisterHealthId',
  AuditLogType.accountRegisterUsername: 'AccountRegisterUsername',
  AuditLogType.accountLinkHealthId: 'AccountLinkHealthId',
  AuditLogType.accountUnlinkHealthId: 'AccountUnlinkHealthId',
  AuditLogType.accountLinkBiometrics: 'AccountLinkBiometrics',
  AuditLogType.accountUnlinkBiometrics: 'AccountUnlinkBiometrics',
  AuditLogType.accountLinkPasskeysOptions: 'AccountLinkPasskeysOptions',
  AuditLogType.accountLinkPasskeysVerify: 'AccountLinkPasskeysVerify',
  AuditLogType.accountUnlinkPasskeys: 'AccountUnlinkPasskeys',
  AuditLogType.accountRegisterPasskeysOptions: 'AccountRegisterPasskeysOptions',
  AuditLogType.accountRegisterPasskeysVerify: 'AccountRegisterPasskeysVerify',
  AuditLogType.accountRegisterGoogle: 'AccountRegisterGoogle',
  AuditLogType.accountRegisterApple: 'AccountRegisterApple',
  AuditLogType.auditLogReadAuthEvents: 'AuditLogReadAuthEvents',
  AuditLogType.authLoginUsername: 'AuthLoginUsername',
  AuditLogType.authLoginEmail: 'AuthLoginEmail',
  AuditLogType.authLoginId: 'AuthLoginId',
  AuditLogType.authLoginHealthId: 'AuthLoginHealthId',
  AuditLogType.authLoginHinRequest: 'AuthLoginHinRequest',
  AuditLogType.authLoginHinConsume: 'AuthLoginHinConsume',
  AuditLogType.authLoginBiometrics: 'AuthLoginBiometrics',
  AuditLogType.authLoginPasskeyOptions: 'AuthLoginPasskeyOptions',
  AuditLogType.authLoginPasskeyVerify: 'AuthLoginPasskeyVerify',
  AuditLogType.authLogin: 'AuthLogin',
  AuditLogType.authLoginGoogle: 'AuthLoginGoogle',
  AuditLogType.authLoginApple: 'AuthLoginApple',
  AuditLogType.authLogout: 'AuthLogout',
  AuditLogType.authGlobalLogout: 'AuthGlobalLogout',
  AuditLogType.authRefresh: 'AuthRefresh',
  AuditLogType.adminAccountRegisterEmail: 'AdminAccountRegisterEmail',
  AuditLogType.adminAccountReadUser: 'AdminAccountReadUser',
  AuditLogType.adminAccountVerifyEmail: 'AdminAccountVerifyEmail',
  AuditLogType.adminAccountDisableUser: 'AdminAccountDisableUser',
  AuditLogType.adminAccountEnableUser: 'AdminAccountEnableUser',
  AuditLogType.adminAccountPasswordChangeRequired:
      'AdminAccountPasswordChangeRequired',
  AuditLogType.adminAccountDeleteUser: 'AdminAccountDeleteUser',
  AuditLogType.adminAccountLogoutUser: 'AdminAccountLogoutUser',
  AuditLogType.adminAccountSetUserRoles: 'AdminAccountSetUserRoles',
  AuditLogType.adminAccountSetUserLicenses: 'AdminAccountSetUserLicenses',
  AuditLogType.adminLicenseCreate: 'AdminLicenseCreate',
  AuditLogType.adminLicenseRead: 'AdminLicenseRead',
  AuditLogType.adminSessionRevokeToken: 'AdminSessionRevokeToken',
  AuditLogType.adminSessionIntrospectToken: 'AdminSessionIntrospectToken',
  AuditLogType.adminTenantAppleDeviceAttestationRead:
      'AdminTenantAppleDeviceAttestationRead',
  AuditLogType.adminTenantAppleDeviceAttestationUpdate:
      'AdminTenantAppleDeviceAttestationUpdate',
  AuditLogType.adminTenantGoogleDeviceAttestationRead:
      'AdminTenantGoogleDeviceAttestationRead',
  AuditLogType.adminTenantGoogleDeviceAttestationUpdate:
      'AdminTenantGoogleDeviceAttestationUpdate',
  AuditLogType.adminTenantGoogleDeviceAttestationSaUpdate:
      'AdminTenantGoogleDeviceAttestationSaUpdate',
  AuditLogType.adminTenantPasswordRequirementsRead:
      'AdminTenantPasswordRequirementsRead',
  AuditLogType.adminTenantPasswordRequirementsUpdate:
      'AdminTenantPasswordRequirementsUpdate',
  AuditLogType.adminTenantMailingOptionsUpdate:
      'AdminTenantMailingOptionsUpdate',
  AuditLogType.adminTenantPasskeyOptionsUpdate:
      'AdminTenantPasskeyOptionsUpdate',
  AuditLogType.adminTenantPasswordRequirementsReset:
      'AdminTenantPasswordRequirementsReset',
  AuditLogType.adminTenantMimotoConfigurationRead:
      'AdminTenantMimotoConfigurationRead',
  AuditLogType.adminTenantMimotoConfigurationUpdate:
      'AdminTenantMimotoConfigurationUpdate',
  AuditLogType.adminTenantTokenDataRead: 'AdminTenantTokenDataRead',
  AuditLogType.adminTenantTokenDataUpdate: 'AdminTenantTokenDataUpdate',
  AuditLogType.adminTenantTenantAccessDataUpdate:
      'AdminTenantTenantAccessDataUpdate',
  AuditLogType.adminTenantExclusiveFeaturesUpdate:
      'AdminTenantExclusiveFeaturesUpdate',
  AuditLogType.adminTenantFlowsRead: 'AdminTenantFlowsRead',
  AuditLogType.adminTenantFlowsUpdate: 'AdminTenantFlowsUpdate',
  AuditLogType.adminTenantIntegrationsUpdate: 'AdminTenantIntegrationsUpdate',
  AuditLogType.adminTenantAuthFlowUpdate: 'AdminTenantAuthFlowUpdate',
  AuditLogType.adminTenantPasswordChangeFlowUpdate:
      'AdminTenantPasswordChangeFlowUpdate',
  AuditLogType.adminTenantRecoveryFlowUpdate: 'AdminTenantRecoveryFlowUpdate',
  AuditLogType.adminTenantVerificationFlowUpdate:
      'AdminTenantVerificationFlowUpdate',
  AuditLogType.challengeAdditionalDevice: 'ChallengeAdditionalDevice',
  AuditLogType.challengeRefresh: 'ChallengeRefresh',
  AuditLogType.challengeLogin: 'ChallengeLogin',
  AuditLogType.challengeRegistration: 'ChallengeRegistration',
  AuditLogType.challengeLinking: 'ChallengeLinking',
  AuditLogType.deviceRegisterAdditionalDeviceViaEmail:
      'DeviceRegisterAdditionalDeviceViaEmail',
  AuditLogType.deviceRegisterAdditionalDeviceViaUsername:
      'DeviceRegisterAdditionalDeviceViaUsername',
  AuditLogType.deviceRegisterAdditionalDeviceViaHealthId:
      'DeviceRegisterAdditionalDeviceViaHealthId',
  AuditLogType.devicePrepareDeviceAttestationKey:
      'DevicePrepareDeviceAttestationKey',
  AuditLogType.deviceRotateDeviceAttestationKey:
      'DeviceRotateDeviceAttestationKey',
  AuditLogType.deviceRefreshBinding: 'DeviceRefreshBinding',
  AuditLogType.efUnknown: 'EfUnknown',
  AuditLogType.efDelete: 'EfDelete',
  AuditLogType.efInsert: 'EfInsert',
  AuditLogType.efRead: 'EfRead',
  AuditLogType.efUpdate: 'EfUpdate',
  AuditLogType.sessionRevokeToken: 'SessionRevokeToken',
  AuditLogType.sessionIntrospectToken: 'SessionIntrospectToken',
  AuditLogType.deviceRegisterAdditionalDeviceViPasskeysOptions:
      'DeviceRegisterAdditionalDeviceViPasskeysOptions',
  AuditLogType.deviceRegisterAdditionalDeviceViPasskeysVerify:
      'DeviceRegisterAdditionalDeviceViPasskeysVerify',
  AuditLogType.adminTenantOidcConfigurationUpdate:
      'AdminTenantOidcConfigurationUpdate',
  AuditLogType.adminTenantWebOptionsDataUpdate:
      'AdminTenantWebOptionsDataUpdate',
  AuditLogType.adminTenantWebOptionsUrlsUpdate:
      'AdminTenantWebOptionsUrlsUpdate',
  AuditLogType.adminTenantWebOptionsLayoutUpdate:
      'AdminTenantWebOptionsLayoutUpdate',
  AuditLogType.adminTenantHinConfigurationUpdate:
      'AdminTenantHinConfigurationUpdate',
};
