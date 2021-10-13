import 'package:json_annotation/json_annotation.dart';

part 'valueset.g.dart';

@JsonSerializable(createToJson: false, genericArgumentFactories: true)
class ValueSet<T> {
  @JsonKey(name: "valueSetId")
  final String id;
  @JsonKey(name: "valueSetDate")
  final DateTime date;
  @JsonKey(name: "valueSetValues")
  final Map<String, T> values;

  ValueSet(this.id, this.values, this.date);

  factory ValueSet.fromJson(
          Map<String, dynamic> json, T Function(Object?) valueFromJson) =>
      _$ValueSetFromJson(json, valueFromJson);
}
