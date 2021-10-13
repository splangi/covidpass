import 'package:json_annotation/json_annotation.dart';

part 'vaccine_prophylaxis.g.dart';

@JsonSerializable(createToJson: false)
class VaccineProphylaxis {
  final String display;
  final String lang;
  final bool active;
  final String version;
  final String system;

  VaccineProphylaxis(
      this.display, this.lang, this.active, this.version, this.system);

  factory VaccineProphylaxis.fromJson(Map<String, dynamic> json) =>
      _$VaccineProphylaxisFromJson(json);
}
