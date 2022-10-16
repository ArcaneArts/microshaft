// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'in_device_success.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InDeviceSuccess _$InDeviceSuccessFromJson(Map<String, dynamic> json) =>
    InDeviceSuccess()
      ..tokenType = json['token_type'] as String?
      ..expiresInSeconds = json['expires_in'] as int?
      ..accessToken = json['access_token'] as String?
      ..refreshToken = json['refresh_token'] as String?
      ..idToken = json['id_token'] as String?
      ..scope = json['scope'] as String?;

Map<String, dynamic> _$InDeviceSuccessToJson(InDeviceSuccess instance) =>
    <String, dynamic>{
      'token_type': instance.tokenType,
      'expires_in': instance.expiresInSeconds,
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
      'id_token': instance.idToken,
      'scope': instance.scope,
    };
