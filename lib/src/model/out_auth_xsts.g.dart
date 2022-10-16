// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'out_auth_xsts.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OutAuthXSTS _$OutAuthXSTSFromJson(Map<String, dynamic> json) => OutAuthXSTS(
      relyingParty: json['RelyingParty'] as String?,
      tokenType: json['TokenType'] as String?,
      properties: json['Properties'] == null
          ? null
          : OutAuthXSTSProperties.fromJson(
              json['Properties'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OutAuthXSTSToJson(OutAuthXSTS instance) =>
    <String, dynamic>{
      'RelyingParty': instance.relyingParty,
      'TokenType': instance.tokenType,
      'Properties': instance.properties?.toJson(),
    };
