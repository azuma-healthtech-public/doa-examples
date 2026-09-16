// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_binding_audit_log_auth_events_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceBindingAuditLogAuthEventsRequest
_$DeviceBindingAuditLogAuthEventsRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate('DeviceBindingAuditLogAuthEventsRequest', json, (
      $checkedConvert,
    ) {
      final val = DeviceBindingAuditLogAuthEventsRequest(
        id: $checkedConvert('id', (v) => v as String?),
        accessToken: $checkedConvert('accessToken', (v) => v as String?),
        page: $checkedConvert('page', (v) => (v as num?)?.toInt()),
        pageSize: $checkedConvert('pageSize', (v) => (v as num?)?.toInt()),
        includedLogTypes: $checkedConvert(
          'includedLogTypes',
          (v) => (v as List<dynamic>?)
              ?.map((e) => $enumDecode(_$AuditLogTypeEnumMap, e))
              .toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$DeviceBindingAuditLogAuthEventsRequestToJson(
  DeviceBindingAuditLogAuthEventsRequest instance,
) => <String, dynamic>{
  'id': ?instance.id,
  'accessToken': ?instance.accessToken,
  'page': ?instance.page,
  'pageSize': ?instance.pageSize,
  'includedLogTypes': ?instance.includedLogTypes
      ?.map((e) => _$AuditLogTypeEnumMap[e]!)
      .toList(),
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
