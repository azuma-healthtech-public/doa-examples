// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ErrorDto _$ErrorDtoFromJson(Map<String, dynamic> json) => $checkedCreate(
  'ErrorDto',
  json,
  ($checkedConvert) {
    final val = ErrorDto(
      error: $checkedConvert(
        'error',
        (v) => $enumDecodeNullable(_$BusinessErrorCodesEnumMap, v),
      ),
      errorDescription: $checkedConvert(
        'error_description',
        (v) => v as String?,
      ),
      errorData: $checkedConvert('error_data', (v) => v),
    );
    return val;
  },
  fieldKeyMap: const {
    'errorDescription': 'error_description',
    'errorData': 'error_data',
  },
);

Map<String, dynamic> _$ErrorDtoToJson(ErrorDto instance) => <String, dynamic>{
  'error': ?_$BusinessErrorCodesEnumMap[instance.error],
  'error_description': ?instance.errorDescription,
  'error_data': ?instance.errorData,
};

const _$BusinessErrorCodesEnumMap = {
  BusinessErrorCodes.unknown: 'Unknown',
  BusinessErrorCodes.applicationUnknown: 'ApplicationUnknown',
  BusinessErrorCodes.authUnauthorized: 'AuthUnauthorized',
  BusinessErrorCodes.authWrongSignature: 'AuthWrongSignature',
  BusinessErrorCodes.authLogoutFailed: 'AuthLogoutFailed',
  BusinessErrorCodes.authGlobalLogoutFailed: 'AuthGlobalLogoutFailed',
  BusinessErrorCodes.authRefreshFailed: 'AuthRefreshFailed',
  BusinessErrorCodes.authAccessTokenInvalid: 'AuthAccessTokenInvalid',
  BusinessErrorCodes.authLoginUsernameDisabled: 'AuthLoginUsernameDisabled',
  BusinessErrorCodes.authLoginUsernameWithDakDisabled:
      'AuthLoginUsernameWithDakDisabled',
  BusinessErrorCodes.authLoginIntegrityDataMissing:
      'AuthLoginIntegrityDataMissing',
  BusinessErrorCodes.authLoginEmailDisabled: 'AuthLoginEmailDisabled',
  BusinessErrorCodes.authLoginIdDisabled: 'AuthLoginIdDisabled',
  BusinessErrorCodes.authLoginHinDisabled: 'AuthLoginHinDisabled',
  BusinessErrorCodes.authLoginHinProviderMissing: 'AuthLoginHinProviderMissing',
  BusinessErrorCodes.authLoginHinProviderNotHin: 'AuthLoginHinProviderNotHin',
  BusinessErrorCodes.authLoginHinDataInvalid: 'AuthLoginHinDataInvalid',
  BusinessErrorCodes.authLoginHinClaimMissing: 'AuthLoginHinClaimMissing',
  BusinessErrorCodes.authLoginEmailWithDakDisabled:
      'AuthLoginEmailWithDakDisabled',
  BusinessErrorCodes.authLoginHealthIdDisabled: 'AuthLoginHealthIdDisabled',
  BusinessErrorCodes.authLoginPasskeysDisabled: 'AuthLoginPasskeysDisabled',
  BusinessErrorCodes.authLoginBiometricsDisabled: 'AuthLoginBiometricsDisabled',
  BusinessErrorCodes.authLoginBiometricsWrongSignature:
      'AuthLoginBiometricsWrongSignature',
  BusinessErrorCodes.authLoginGoogleTeDisabled: 'AuthLoginGoogleTeDisabled',
  BusinessErrorCodes.authLoginAppleTeDisabled: 'AuthLoginAppleTeDisabled',
  BusinessErrorCodes.changePasswordLoginRequired: 'ChangePasswordLoginRequired',
  BusinessErrorCodes.changePasswordFailed: 'ChangePasswordFailed',
  BusinessErrorCodes.changePasswordDisabled: 'ChangePasswordDisabled',
  BusinessErrorCodes.deviceAttestationKeyUnknown: 'DeviceAttestationKeyUnknown',
  BusinessErrorCodes.deviceBindingUnknownMobileOs:
      'DeviceBindingUnknownMobileOs',
  BusinessErrorCodes.deviceBindingInvalidIntegrity:
      'DeviceBindingInvalidIntegrity',
  BusinessErrorCodes.deviceBindingInvalidAttestation:
      'DeviceBindingInvalidAttestation',
  BusinessErrorCodes.deviceBindingInvalidAssertion:
      'DeviceBindingInvalidAssertion',
  BusinessErrorCodes.deviceBindingPayloadInvalid: 'DeviceBindingPayloadInvalid',
  BusinessErrorCodes.deviceBindingRefreshDisabled:
      'DeviceBindingRefreshDisabled',
  BusinessErrorCodes.emailUnknown: 'EmailUnknown',
  BusinessErrorCodes.emailAlreadyVerified: 'EmailAlreadyVerified',
  BusinessErrorCodes.emailConfirmationFailed: 'EmailConfirmationFailed',
  BusinessErrorCodes.emailFormatInvalid: 'EmailFormatInvalid',
  BusinessErrorCodes.emailNotVerified: 'EmailNotVerified',
  BusinessErrorCodes.emailVerificationDisabled: 'EmailVerificationDisabled',
  BusinessErrorCodes.forbidden: 'Forbidden',
  BusinessErrorCodes.notFound: 'NotFound',
  BusinessErrorCodes.oidcUnknown: 'OidcUnknown',
  BusinessErrorCodes.licenseKeyMissing: 'LicenseKeyMissing',
  BusinessErrorCodes.licenseKeyNotStartingWithAppShortKey:
      'LicenseKeyNotStartingWithAppShortKey',
  BusinessErrorCodes.licenseKeyMinLength: 'LicenseKeyMinLength',
  BusinessErrorCodes.licenseKeyReserved: 'LicenseKeyReserved',
  BusinessErrorCodes.licenseKeyOnlyLetters: 'LicenseKeyOnlyLetters',
  BusinessErrorCodes.licensePersonalButNoUser: 'LicensePersonalButNoUser',
  BusinessErrorCodes.licenseTenantButNoTenant: 'LicenseTenantButNoTenant',
  BusinessErrorCodes.licenseUnknown: 'LicenseUnknown',
  BusinessErrorCodes.linkHealthIdAlreadyLinked: 'LinkHealthIdAlreadyLinked',
  BusinessErrorCodes.linkHealthIdSubAlreadyLinked:
      'LinkHealthIdSubAlreadyLinked',
  BusinessErrorCodes.linkHealthIdNotLinked: 'LinkHealthIdNotLinked',
  BusinessErrorCodes.linkHinAlreadyLinked: 'LinkHinAlreadyLinked',
  BusinessErrorCodes.linkHinSubAlreadyLinked: 'LinkHinSubAlreadyLinked',
  BusinessErrorCodes.linkHinNotLinked: 'LinkHinNotLinked',
  BusinessErrorCodes.linkHinIdUnlinkNotPossible: 'LinkHinIdUnlinkNotPossible',
  BusinessErrorCodes.linkHealthIdUnlinkNotPossible:
      'LinkHealthIdUnlinkNotPossible',
  BusinessErrorCodes.linkBiometricsInvalidPublicKey:
      'LinkBiometricsInvalidPublicKey',
  BusinessErrorCodes.linkBiometricsInvalidSignature:
      'LinkBiometricsInvalidSignature',
  BusinessErrorCodes.linkPasskeyVerificationFailed:
      'LinkPasskeyVerificationFailed',
  BusinessErrorCodes.paginationPageSizeNotAllowed:
      'PaginationPageSizeNotAllowed',
  BusinessErrorCodes.passkeyCredentialUnknown: 'PasskeyCredentialUnknown',
  BusinessErrorCodes.passkeyUnlinkNotPossible: 'PasskeyUnlinkNotPossible',
  BusinessErrorCodes.permissionKeyMissing: 'PermissionKeyMissing',
  BusinessErrorCodes.permissionKeyNotStartingWithAppShortKey:
      'PermissionKeyNotStartingWithAppShortKey',
  BusinessErrorCodes.permissionKeyMinLength: 'PermissionKeyMinLength',
  BusinessErrorCodes.permissionKeyReserved: 'PermissionKeyReserved',
  BusinessErrorCodes.permissionKeyOnlyLetters: 'PermissionKeyOnlyLetters',
  BusinessErrorCodes.permissionAlreadyExists: 'PermissionAlreadyExists',
  BusinessErrorCodes.recoveryDisabled: 'RecoveryDisabled',
  BusinessErrorCodes.recoveryConfirmationFailed: 'RecoveryConfirmationFailed',
  BusinessErrorCodes.registrationNotPossible: 'RegistrationNotPossible',
  BusinessErrorCodes.registrationPasswordValidationFailed:
      'RegistrationPasswordValidationFailed',
  BusinessErrorCodes.registrationHealthIdFailed: 'RegistrationHealthIdFailed',
  BusinessErrorCodes.registrationUsernameDisabled:
      'RegistrationUsernameDisabled',
  BusinessErrorCodes.registrationEmailDisabled: 'RegistrationEmailDisabled',
  BusinessErrorCodes.registrationHealthIdDisabled:
      'RegistrationHealthIdDisabled',
  BusinessErrorCodes.registrationPasskeysDisabled:
      'RegistrationPasskeysDisabled',
  BusinessErrorCodes.registrationPasskeyVerificationFailed:
      'RegistrationPasskeyVerificationFailed',
  BusinessErrorCodes.registrationGoogleTeDisabled:
      'RegistrationGoogleTeDisabled',
  BusinessErrorCodes.registrationAppleTeDisabled: 'RegistrationAppleTeDisabled',
  BusinessErrorCodes.registrationOidcFailed: 'RegistrationOidcFailed',
  BusinessErrorCodes.roleAddPermissionApplicationMismatch:
      'RoleAddPermissionApplicationMismatch',
  BusinessErrorCodes.roleRemovePermissionApplicationMismatch:
      'RoleRemovePermissionApplicationMismatch',
  BusinessErrorCodes.roleKeyMissing: 'RoleKeyMissing',
  BusinessErrorCodes.roleKeyNotStartingWithAppShortKey:
      'RoleKeyNotStartingWithAppShortKey',
  BusinessErrorCodes.roleKeyMinLength: 'RoleKeyMinLength',
  BusinessErrorCodes.roleKeyReserved: 'RoleKeyReserved',
  BusinessErrorCodes.roleKeyOnlyLetters: 'RoleKeyOnlyLetters',
  BusinessErrorCodes.roleUnknown: 'RoleUnknown',
  BusinessErrorCodes.roleAlreadyExists: 'RoleAlreadyExists',
  BusinessErrorCodes.scopeNotAllowed: 'ScopeNotAllowed',
  BusinessErrorCodes.sessionIntrospectionFailed: 'SessionIntrospectionFailed',
  BusinessErrorCodes.sessionRevokeTokenFailed: 'SessionRevokeTokenFailed',
  BusinessErrorCodes.userEnableFailed: 'UserEnableFailed',
  BusinessErrorCodes.userDisableFailed: 'UserDisableFailed',
  BusinessErrorCodes.userDeleteFailed: 'UserDeleteFailed',
  BusinessErrorCodes.userReadFailed: 'UserReadFailed',
  BusinessErrorCodes.userUnknown: 'UserUnknown',
  BusinessErrorCodes.specValidationError: 'SpecValidationError',
};
