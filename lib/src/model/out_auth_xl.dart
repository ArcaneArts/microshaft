import 'package:json_annotation/json_annotation.dart';
import 'package:microshaft/src/model/out_auth_xl_properties.dart';

part 'out_auth_xl.g.dart';

@JsonSerializable(explicitToJson: true)
class OutAuthXL {
  @JsonKey(name: "RelyingParty")
  String? relyingParty;
  @JsonKey(name: "TokenType")
  String? tokenType;
  @JsonKey(name: "Properties")
  OutAuthXLProperties? properties;

  OutAuthXL({this.relyingParty, this.tokenType, this.properties});

  factory OutAuthXL.fromJson(Map<String, dynamic> json) =>
      _$OutAuthXLFromJson(json);

  Map<String, dynamic> toJson() => _$OutAuthXLToJson(this);
}
