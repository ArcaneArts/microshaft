import 'package:json_annotation/json_annotation.dart';
import 'package:microshaft/src/model/out_auth_xl_properties.dart';

part 'in_auth_xl.g.dart';

@JsonSerializable(explicitToJson: true)
class InAuthXL {
  @JsonKey(name: "IssueInstant")
  String? issueInstant;
  @JsonKey(name: "NotAfter")
  String? notAfter;
  @JsonKey(name: "Token")
  String? token;
  @JsonKey(name: "DisplayClaims")
  Map<String, dynamic>? displayClaims;

  InAuthXL();

  String? getUserHash() => ((displayClaims?["xui"] as List<dynamic>)[0]
      as Map<String, dynamic>)["uhs"];

  factory InAuthXL.fromJson(Map<String, dynamic> json) =>
      _$InAuthXLFromJson(json);

  Map<String, dynamic> toJson() => _$InAuthXLToJson(this);
}
