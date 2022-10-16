// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'out_auth_xsts_properties.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OutAuthXSTSProperties _$OutAuthXSTSPropertiesFromJson(
        Map<String, dynamic> json) =>
    OutAuthXSTSProperties(
      sandboxId: json['SandboxId'] as String?,
      userTokens: (json['UserTokens'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$OutAuthXSTSPropertiesToJson(
        OutAuthXSTSProperties instance) =>
    <String, dynamic>{
      'SandboxId': instance.sandboxId,
      'UserTokens': instance.userTokens,
    };
