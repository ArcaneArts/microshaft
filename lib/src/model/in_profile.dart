import 'package:json_annotation/json_annotation.dart';
import 'package:microshaft/src/model/out_auth_xl_properties.dart';

part 'in_profile.g.dart';

@JsonSerializable(explicitToJson: true)
class InProfile {
  String? id;
  String? name;
  List<dynamic>? capes;
  List<dynamic>? skins;

  InProfile();

  factory InProfile.fromJson(Map<String, dynamic> json) =>
      _$InProfileFromJson(json);

  Map<String, dynamic> toJson() => _$InProfileToJson(this);
}
