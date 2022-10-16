import 'package:json_annotation/json_annotation.dart';
import 'package:microshaft/src/model/out_auth_xsts_properties.dart';

part 'out_auth_xsts.g.dart';

@JsonSerializable(explicitToJson: true)
class OutAuthXSTS {
  @JsonKey(name: "RelyingParty")
  String? relyingParty;
  @JsonKey(name: "TokenType")
  String? tokenType;
  @JsonKey(name: "Properties")
  OutAuthXSTSProperties? properties;

  OutAuthXSTS({this.relyingParty, this.tokenType, this.properties});

  factory OutAuthXSTS.fromJson(Map<String, dynamic> json) =>
      _$OutAuthXSTSFromJson(json);

  Map<String, dynamic> toJson() => _$OutAuthXSTSToJson(this);
}
