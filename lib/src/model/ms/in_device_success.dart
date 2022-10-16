import 'package:json_annotation/json_annotation.dart';

part 'in_device_success.g.dart';

@JsonSerializable()
class InDeviceSuccess {
  @JsonKey(name: "token_type")
  String? tokenType;
  @JsonKey(name: "expires_in")
  int? expiresInSeconds;
  @JsonKey(name: "access_token")
  String? accessToken;
  @JsonKey(name: "refresh_token")
  String? refreshToken;
  @JsonKey(name: "id_token")
  String? idToken;
  String? scope;

  InDeviceSuccess();

  factory InDeviceSuccess.fromJson(Map<String, dynamic> json) =>
      _$InDeviceSuccessFromJson(json);

  Map<String, dynamic> toJson() => _$InDeviceSuccessToJson(this);
}
