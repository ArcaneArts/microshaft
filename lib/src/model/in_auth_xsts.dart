import 'package:json_annotation/json_annotation.dart';
import 'package:microshaft/src/model/out_auth_xl_properties.dart';

part 'in_auth_xsts.g.dart';

@JsonSerializable(explicitToJson: true)
class InAuthXSTS {
  @JsonKey(name: "IssueInstant")
  String? issueInstant;
  @JsonKey(name: "NotAfter")
  String? notAfter;
  @JsonKey(name: "Token")
  String? token;
  @JsonKey(name: "DisplayClaims")
  Map<String, dynamic>? displayClaims;

  InAuthXSTS();

  String? getUserHash() => ((displayClaims?["xui"] as List<dynamic>)[0]
      as Map<String, dynamic>)["uhs"];

  factory InAuthXSTS.fromJson(Map<String, dynamic> json) =>
      _$InAuthXSTSFromJson(json);

  Map<String, dynamic> toJson() => _$InAuthXSTSToJson(this);
}
