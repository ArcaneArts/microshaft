// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'out_auth_xl_properties.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OutAuthXLProperties _$OutAuthXLPropertiesFromJson(Map<String, dynamic> json) =>
    OutAuthXLProperties(
      authMethod: json['AuthMethod'] as String?,
      siteName: json['SiteName'] as String?,
      rpsTicket: json['RpsTicket'] as String?,
    );

Map<String, dynamic> _$OutAuthXLPropertiesToJson(
        OutAuthXLProperties instance) =>
    <String, dynamic>{
      'AuthMethod': instance.authMethod,
      'SiteName': instance.siteName,
      'RpsTicket': instance.rpsTicket,
    };
