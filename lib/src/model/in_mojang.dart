import 'package:json_annotation/json_annotation.dart';

part 'in_mojang.g.dart';

@JsonSerializable(explicitToJson: true)
class InMojang {
  String? username;
  List<String>? roles;
  @JsonKey(name: "access_token")
  String? accessToken;
  @JsonKey(name: "token_type")
  String? tokenType;
  @JsonKey(name: "expires_in")
  int? expiresIn;

  InMojang();

  factory InMojang.fromJson(Map<String, dynamic> json) =>
      _$InMojangFromJson(json);

  Map<String, dynamic> toJson() => _$InMojangToJson(this);
}
