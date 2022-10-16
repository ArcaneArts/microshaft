import 'package:json_annotation/json_annotation.dart';

part 'in_device_code.g.dart';

@JsonSerializable()
class InDeviceCode {
  @JsonKey(name: "device_code")
  String? deviceCode;
  @JsonKey(name: "user_code")
  String? userCode;
  @JsonKey(name: "verification_uri")
  String? verificationUri;
  @JsonKey(name: "expires_in")
  int? expiresInSeconds;
  @JsonKey(name: "interval")
  int? intervalSeconds;
  String? message;

  InDeviceCode();

  factory InDeviceCode.fromJson(Map<String, dynamic> json) =>
      _$InDeviceCodeFromJson(json);

  Map<String, dynamic> toJson() => _$InDeviceCodeToJson(this);
}
