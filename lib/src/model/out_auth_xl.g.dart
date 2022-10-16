// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'out_auth_xl.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OutAuthXL _$OutAuthXLFromJson(Map<String, dynamic> json) => OutAuthXL(
      relyingParty: json['RelyingParty'] as String?,
      tokenType: json['TokenType'] as String?,
      properties: json['Properties'] == null
          ? null
          : OutAuthXLProperties.fromJson(
              json['Properties'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OutAuthXLToJson(OutAuthXL instance) => <String, dynamic>{
      'RelyingParty': instance.relyingParty,
      'TokenType': instance.tokenType,
      'Properties': instance.properties?.toJson(),
    };
