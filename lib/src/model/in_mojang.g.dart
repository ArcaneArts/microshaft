// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'in_mojang.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InMojang _$InMojangFromJson(Map<String, dynamic> json) => InMojang()
  ..username = json['username'] as String?
  ..roles = (json['roles'] as List<dynamic>?)?.map((e) => e as String).toList()
  ..accessToken = json['access_token'] as String?
  ..tokenType = json['token_type'] as String?
  ..expiresIn = json['expires_in'] as int?;

Map<String, dynamic> _$InMojangToJson(InMojang instance) => <String, dynamic>{
      'username': instance.username,
      'roles': instance.roles,
      'access_token': instance.accessToken,
      'token_type': instance.tokenType,
      'expires_in': instance.expiresIn,
    };
