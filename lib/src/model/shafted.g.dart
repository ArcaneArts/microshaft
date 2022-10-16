// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shafted.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Shafted _$ShaftedFromJson(Map<String, dynamic> json) => Shafted()
  ..microsoftAccessToken = json['microsoftAccessToken'] as String?
  ..xblToken = json['xblToken'] as String?
  ..xstsToken = json['xstsToken'] as String?
  ..mojangToken = json['mojangToken'] as String?
  ..username = json['username'] as String?
  ..userHash = json['userHash'] as String?;

Map<String, dynamic> _$ShaftedToJson(Shafted instance) => <String, dynamic>{
      'microsoftAccessToken': instance.microsoftAccessToken,
      'xblToken': instance.xblToken,
      'xstsToken': instance.xstsToken,
      'mojangToken': instance.mojangToken,
      'username': instance.username,
      'userHash': instance.userHash,
    };
