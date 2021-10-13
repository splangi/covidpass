

import 'package:json_annotation/json_annotation.dart';

part 'vaccine_product.g.dart';

@JsonSerializable(createToJson: false)
class VaccineProduct {

  final String display;
  final String lang;
  final bool active;
  final String system;
  final String version;

  VaccineProduct(this.display, this.lang, this.active, this.system, this.version);


  factory VaccineProduct.fromJson(Map<String, dynamic> json) => _$VaccineProductFromJson(json);


}