import 'package:json_annotation/json_annotation.dart';
import 'package:microshaft/src/model/out_auth_xl_properties.dart';

part 'out_auth_xsts_properties.g.dart';

@JsonSerializable(explicitToJson: true)
class OutAuthXSTSProperties {
  @JsonKey(name: "SandboxId")
  String? sandboxId;
  @JsonKey(name: "UserTokens")
  List<String>? userTokens;

  OutAuthXSTSProperties({this.sandboxId, this.userTokens});

  factory OutAuthXSTSProperties.fromJson(Map<String, dynamic> json) =>
      _$OutAuthXSTSPropertiesFromJson(json);

  Map<String, dynamic> toJson() => _$OutAuthXSTSPropertiesToJson(this);
}
