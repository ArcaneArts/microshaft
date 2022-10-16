// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'in_auth_xl.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InAuthXL _$InAuthXLFromJson(Map<String, dynamic> json) => InAuthXL()
  ..issueInstant = json['IssueInstant'] as String?
  ..notAfter = json['NotAfter'] as String?
  ..token = json['Token'] as String?
  ..displayClaims = json['DisplayClaims'] as Map<String, dynamic>?;

Map<String, dynamic> _$InAuthXLToJson(InAuthXL instance) => <String, dynamic>{
      'IssueInstant': instance.issueInstant,
      'NotAfter': instance.notAfter,
      'Token': instance.token,
      'DisplayClaims': instance.displayClaims,
    };
