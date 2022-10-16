import 'package:json_annotation/json_annotation.dart';
import 'package:microshaft/src/model/out_auth_xl_properties.dart';

part 'shafted.g.dart';

@JsonSerializable()
class Shafted {
  String? microsoftAccessToken;
  String? xblToken;
  String? xstsToken;
  String? mojangToken;
  String? username;
  String? userHash;
  String? uuid;
  String? profileName;

  Shafted();

  factory Shafted.fromJson(Map<String, dynamic> json) =>
      _$ShaftedFromJson(json);

  Map<String, dynamic> toJson() => _$ShaftedToJson(this);
}
