// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'in_auth_xsts.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InAuthXSTS _$InAuthXSTSFromJson(Map<String, dynamic> json) => InAuthXSTS()
  ..issueInstant = json['IssueInstant'] as String?
  ..notAfter = json['NotAfter'] as String?
  ..token = json['Token'] as String?
  ..displayClaims = json['DisplayClaims'] as Map<String, dynamic>?;

Map<String, dynamic> _$InAuthXSTSToJson(InAuthXSTS instance) =>
    <String, dynamic>{
      'IssueInstant': instance.issueInstant,
      'NotAfter': instance.notAfter,
      'Token': instance.token,
      'DisplayClaims': instance.displayClaims,
    };
