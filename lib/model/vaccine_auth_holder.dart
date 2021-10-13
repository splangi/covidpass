
import 'package:json_annotation/json_annotation.dart';

part 'vaccine_auth_holder.g.dart';

@JsonSerializable(createToJson: false)
class VaccineAuthHolder {
  final String display;
  final String lang;
  final bool active;
  final String system;
  final String version;

  VaccineAuthHolder(
      {required this.display, required this.lang, required this.active, required this.system, required this.version});

  factory VaccineAuthHolder.fromJson(Map<String, dynamic> json) => _$VaccineAuthHolderFromJson(json);

}
