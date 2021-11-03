import 'package:json_annotation/json_annotation.dart';

part 'certificate.g.dart';

class Certificate {
  final CertificateData data;
  final String rawData;

  Certificate(this.data, this.rawData);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Certificate &&
          runtimeType == other.runtimeType &&
          rawData == other.rawData;

  @override
  int get hashCode => rawData.hashCode;
}

enum CertificateType { vaccination, recovery, test }

@JsonSerializable(createToJson: false, anyMap: true)
class CertificateData {
  @JsonKey(name: "ver")
  final String version;
  @JsonKey(name: "nam")
  final Person person;
  @JsonKey(name: "v")
  final List<VaccinationCertificate>? vaccinationCertificates;
  @JsonKey(name: "r")
  final List<RecoveryCertificate>? recoveryCertificates;
  @JsonKey(name: "t")
  final List<TestCertificate>? testCertificates;
  @JsonKey(name: "dob")
  final DateTime dateOfBirth;

  CertificateType get type {
    if (vaccinationCertificates != null) {
      return CertificateType.vaccination;
    } else if (recoveryCertificates != null) {
      return CertificateType.recovery;
    } else if (testCertificates != null) {
      return CertificateType.test;
    }
    throw Exception("Certificate data does not contain v, r or t");
  }

  String get identifier {
    switch (type) {
      case CertificateType.vaccination:
        return vaccinationCertificate!.identifier;
      case CertificateType.recovery:
        return recoveryCertificate!.identifier;
      case CertificateType.test:
        return testCertificate!.identifier;
    }
  }

  VaccinationCertificate? get vaccinationCertificate =>
      vaccinationCertificates?.first;

  RecoveryCertificate? get recoveryCertificate => recoveryCertificates?.first;

  TestCertificate? get testCertificate => testCertificates?.first;

  factory CertificateData.fromJson(Map<String, dynamic> json) =>
      _$CertificateDataFromJson(json);

  const CertificateData(this.version, this.person, this.vaccinationCertificates,
      this.recoveryCertificates, this.testCertificates, this.dateOfBirth);
}

@JsonSerializable(createToJson: false, anyMap: true)
class Person {
  @JsonKey(name: "fn")
  final String surnames;
  @JsonKey(name: "gn")
  final String forenames;

  Person(this.surnames, this.forenames);

  factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);
}

@JsonSerializable(createToJson: false, anyMap: true)
class VaccinationCertificate {
  @JsonKey(name: "tg")
  final String target;
  @JsonKey(name: "vp")
  final String type;
  @JsonKey(name: "mp")
  final String product;
  @JsonKey(name: "ma")
  final String authHolder;
  @JsonKey(name: "dn")
  final int doses;
  @JsonKey(name: "sd")
  final int overallDoses;
  @JsonKey(name: "dt")
  final DateTime dateOfVaccination;
  @JsonKey(name: "co")
  final String country;
  @JsonKey(name: "is")
  final String issuer;
  @JsonKey(name: "ci")
  final String identifier;

  VaccinationCertificate(
      this.target,
      this.type,
      this.product,
      this.authHolder,
      this.doses,
      this.overallDoses,
      this.dateOfVaccination,
      this.country,
      this.issuer,
      this.identifier);

  factory VaccinationCertificate.fromJson(Map<String, dynamic> json) =>
      _$VaccinationCertificateFromJson(json);
}

@JsonSerializable(createToJson: false, anyMap: true)
class TestCertificate {
  @JsonKey(name: "tg")
  final String target;
  @JsonKey(name: "tt", unknownEnumValue: TestType.unknown)
  final TestType type;
  @JsonKey(name: "nm")
  final String? testNameNAAT;
  @JsonKey(name: "ma")
  final String? testDeviceIdentifierRAT;
  @JsonKey(name: "sc")
  final DateTime testSampleCollectionTime;
  @JsonKey(name: "tr", unknownEnumValue: TestResult.unknown)
  final TestResult testResult;
  @JsonKey(name: "tc")
  final String testingCentre;
  @JsonKey(name: "co")
  final String country;
  @JsonKey(name: "is")
  final String issuer;
  @JsonKey(name: "ci")
  final String identifier;

  TestCertificate(
      this.target,
      this.type,
      this.testNameNAAT,
      this.testDeviceIdentifierRAT,
      this.testSampleCollectionTime,
      this.testResult,
      this.testingCentre,
      this.country,
      this.issuer,
      this.identifier);

  factory TestCertificate.fromJson(Map<String, dynamic> json) =>
      _$TestCertificateFromJson(json);
}

enum TestType {
  @JsonValue("LP6464-4")
  naat,
  @JsonValue("LP217198-3")
  rat,
  unknown,
}

enum TestResult {
  @JsonValue("260415000")
  notDetected,
  @JsonValue("260373001")
  detected,
  unknown,
}

@JsonSerializable(createToJson: false, anyMap: true)
class RecoveryCertificate {
  @JsonKey(name: "tg")
  final String target;
  @JsonKey(name: "fr")
  final DateTime dateOfPositiveResult;
  @JsonKey(name: "df")
  final DateTime validFrom;
  @JsonKey(name: "du")
  final DateTime validUntil;
  @JsonKey(name: "co")
  final String country;
  @JsonKey(name: "is")
  final String issuer;
  @JsonKey(name: "ci")
  final String identifier;

  RecoveryCertificate(this.target, this.dateOfPositiveResult, this.validFrom,
      this.validUntil, this.country, this.issuer, this.identifier);

  factory RecoveryCertificate.fromJson(Map<String, dynamic> json) =>
      _$RecoveryCertificateFromJson(json);
}
