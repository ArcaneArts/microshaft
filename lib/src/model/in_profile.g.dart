// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'in_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InProfile _$InProfileFromJson(Map<String, dynamic> json) => InProfile()
  ..id = json['id'] as String?
  ..name = json['name'] as String?
  ..capes = json['capes'] as List<dynamic>?
  ..skins = json['skins'] as List<dynamic>?;

Map<String, dynamic> _$InProfileToJson(InProfile instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'capes': instance.capes,
      'skins': instance.skins,
    };
