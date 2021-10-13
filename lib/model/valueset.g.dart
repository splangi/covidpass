// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'valueset.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ValueSet<T> _$ValueSetFromJson<T>(
  Map json,
  T Function(Object? json) fromJsonT,
) =>
    ValueSet<T>(
      json['valueSetId'] as String,
      (json['valueSetValues'] as Map).map(
        (k, e) => MapEntry(k as String, fromJsonT(e)),
      ),
      DateTime.parse(json['valueSetDate'] as String),
    );
