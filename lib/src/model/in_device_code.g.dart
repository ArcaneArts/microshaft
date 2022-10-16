// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'in_device_code.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InDeviceCode _$InDeviceCodeFromJson(Map<String, dynamic> json) => InDeviceCode()
  ..deviceCode = json['device_code'] as String?
  ..userCode = json['user_code'] as String?
  ..verificationUri = json['verification_uri'] as String?
  ..expiresInSeconds = json['expires_in'] as int?
  ..intervalSeconds = json['interval'] as int?
  ..message = json['message'] as String?;

Map<String, dynamic> _$InDeviceCodeToJson(InDeviceCode instance) =>
    <String, dynamic>{
      'device_code': instance.deviceCode,
      'user_code': instance.userCode,
      'verification_uri': instance.verificationUri,
      'expires_in': instance.expiresInSeconds,
      'interval': instance.intervalSeconds,
      'message': instance.message,
    };
