// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'certificate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CertificateData _$CertificateDataFromJson(Map json) => CertificateData(
      json['ver'] as String,
      Person.fromJson(Map<String, dynamic>.from(json['nam'] as Map)),
      (json['v'] as List<dynamic>?)
          ?.map((e) => VaccinationCertificate.fromJson(
              Map<String, dynamic>.from(e as Map)))
          .toList(),
      (json['r'] as List<dynamic>?)
          ?.map((e) =>
              RecoveryCertificate.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      (json['t'] as List<dynamic>?)
          ?.map((e) =>
              TestCertificate.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      DateTime.parse(json['dob'] as String),
    );

Person _$PersonFromJson(Map json) => Person(
      json['fn'] as String,
      json['gn'] as String,
    );

VaccinationCertificate _$VaccinationCertificateFromJson(Map json) =>
    VaccinationCertificate(
      json['tg'] as String,
      json['vp'] as String,
      json['mp'] as String,
      json['ma'] as String,
      json['dn'] as int,
      json['sd'] as int,
      DateTime.parse(json['dt'] as String),
      json['co'] as String,
      json['is'] as String,
      json['ci'] as String,
    );

TestCertificate _$TestCertificateFromJson(Map json) => TestCertificate(
      json['tg'] as String,
      _$enumDecode(_$TestTypeEnumMap, json['tt'],
          unknownValue: TestType.unknown),
      json['nm'] as String?,
      json['ma'] as String?,
      DateTime.parse(json['sc'] as String),
      _$enumDecode(_$TestResultEnumMap, json['tr'],
          unknownValue: TestResult.unknown),
      json['tc'] as String,
      json['co'] as String,
      json['is'] as String,
      json['ci'] as String,
    );

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

const _$TestTypeEnumMap = {
  TestType.naat: 'LP6464-4',
  TestType.rat: 'LP217198-3',
  TestType.unknown: 'unknown',
};

const _$TestResultEnumMap = {
  TestResult.notDetected: '260415000',
  TestResult.detected: '260373001',
  TestResult.unknown: 'unknown',
};

RecoveryCertificate _$RecoveryCertificateFromJson(Map json) =>
    RecoveryCertificate(
      json['tg'] as String,
      DateTime.parse(json['fr'] as String),
      DateTime.parse(json['df'] as String),
      DateTime.parse(json['du'] as String),
      json['co'] as String,
      json['is'] as String,
      json['ci'] as String,
    );
