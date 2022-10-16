import 'package:json_annotation/json_annotation.dart';

part 'out_auth_xl_properties.g.dart';

@JsonSerializable()
class OutAuthXLProperties {
  @JsonKey(name: "AuthMethod")
  String? authMethod;
  @JsonKey(name: "SiteName")
  String? siteName;
  @JsonKey(name: "RpsTicket")
  String? rpsTicket;

  OutAuthXLProperties({this.authMethod, this.siteName, this.rpsTicket});

  factory OutAuthXLProperties.fromJson(Map<String, dynamic> json) =>
      _$OutAuthXLPropertiesFromJson(json);

  Map<String, dynamic> toJson() => _$OutAuthXLPropertiesToJson(this);
}
