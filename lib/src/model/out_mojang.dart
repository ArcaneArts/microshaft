import 'package:json_annotation/json_annotation.dart';

part 'out_mojang.g.dart';

@JsonSerializable(explicitToJson: true)
class OutMojang {
  String? identityToken;

  OutMojang({this.identityToken});

  factory OutMojang.fromJson(Map<String, dynamic> json) =>
      _$OutMojangFromJson(json);

  Map<String, dynamic> toJson() => _$OutMojangToJson(this);
}
