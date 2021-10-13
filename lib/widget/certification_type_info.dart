import 'package:coronapass/certificate.dart';
import 'package:coronapass/extensions/iterable_extensions.dart';
import 'package:coronapass/generated/l10n.dart';
import 'package:coronapass/model/vaccine_auth_holder.dart';
import 'package:coronapass/model/vaccine_product.dart';
import 'package:coronapass/model/vaccine_prophylaxis.dart';
import 'package:coronapass/model/valueset.dart';
import 'package:coronapass/widget/certificate_row.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class _CertificateInfo extends StatelessWidget {
  final List<Widget> rows;

  const _CertificateInfo({Key? key, required this.rows}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: rows
            .intersperse(
                Container(
                  height: 20.0,
                ),
                rows)
            .toList(growable: false));
  }
}

class TestInfo extends StatelessWidget {
  final TestCertificate certificate;
  final DateFormat df = DateFormat("dd.MM.yyyy");

  TestInfo({Key? key, required this.certificate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? resultText;

    switch (certificate.testResult) {
      case TestResult.notDetected:
        resultText = S.of(context).negative;
        break;
      case TestResult.detected:
        resultText = S.of(context).positive;
        break;
      case TestResult.unknown:
        resultText = null;
        break;
    }

    String? testTypeText;

    switch (certificate.type) {
      case TestType.naat:
        testTypeText = S.of(context).nucleicAcidAmplificationTest;
        break;
      case TestType.rat:
        testTypeText = S.of(context).rapidAntigenTest;
        break;
      case TestType.unknown:
        testTypeText = null;
        break;
    }

    return _CertificateInfo(
      rows: [
        if (resultText != null) CertRow(title: S.of(context).result, value: resultText),
        CertRow(
            title: S.of(context).sampleCollectionTime,
            value: df.format(certificate.testSampleCollectionTime)),
        if (testTypeText != null)
          CertRow(
            title: S.of(context).testType,
            value: testTypeText,
          ),
        if (certificate.testNameNAAT?.isNotEmpty == true)
          CertRow(title: S.of(context).testName, value: certificate.testNameNAAT!),
        CertRow(title: S.of(context).testingCentre, value: certificate.testingCentre),
        CertRow(
          title: S.of(context).issuer,
          value: certificate.issuer,
        ),
        CertRow(title: S.of(context).country, value: certificate.country),
      ],
    );
  }
}

class RecoveryInfo extends StatelessWidget {
  final RecoveryCertificate certificate;
  final DateFormat df = DateFormat("dd.MM.yyyy");

  RecoveryInfo({Key? key, required this.certificate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _CertificateInfo(
      rows: [
        CertRow(title: S.of(context).validFrom, value: df.format(certificate.validFrom)),
        CertRow(title: S.of(context).validUntil, value: df.format(certificate.validUntil)),
        CertRow(
            title: S.of(context).dateOfPositiveResult,
            value: df.format(certificate.dateOfPositiveResult)),
        CertRow(
          title: S.of(context).issuer,
          value: certificate.issuer,
        ),
        CertRow(title: S.of(context).country, value: certificate.country),
      ],
    );
    ;
  }
}

class VaccinationInfo extends StatelessWidget {
  final VaccinationCertificate certificate;
  final DateFormat df = DateFormat("dd.MM.yyyy");

  VaccinationInfo({Key? key, required this.certificate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final products = context.read<ValueSet<VaccineProduct>?>();
    final authHolders = context.read<ValueSet<VaccineAuthHolder>?>();

    return _CertificateInfo(
      rows: [
        CertRow(
            title: S.of(context).dateOfVaccination,
            value: df.format(certificate.dateOfVaccination)),
        CertRow(
            title: S.of(context).doses,
            value: "${certificate.doses}/${certificate.overallDoses}"),
        CertRow(
            title: S.of(context).vaccine,
            value: products?.values[certificate.product]?.display ??
                certificate.product),
        CertRow(
            title: S.of(context).authorizationHolder,
            value: authHolders?.values[certificate.authHolder]?.display ??
                certificate.authHolder),
        CertRow(title: S.of(context).vaccinationCountry, value: certificate.country),
      ],
    );
  }
}
