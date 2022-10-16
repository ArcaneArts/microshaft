import 'package:json_annotation/json_annotation.dart';

part 'in_device_error.g.dart';

@JsonSerializable()
class InDeviceError {
  String? error;

  InDeviceError();

  factory InDeviceError.fromJson(Map<String, dynamic> json) =>
      _$InDeviceErrorFromJson(json);

  Map<String, dynamic> toJson() => _$InDeviceErrorToJson(this);
}
