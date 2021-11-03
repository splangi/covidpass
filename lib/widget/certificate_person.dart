import 'package:coronapass/model/certificate.dart';
import 'package:coronapass/generated/l10n.dart';
import 'package:coronapass/widget/certificate_row.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CertificatePerson extends StatelessWidget {
  final Certificate certificate;
  final DateFormat df = DateFormat("dd.MM.yyyy");

  CertificatePerson({Key? key, required this.certificate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: certificate.rawData + "_person",
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CertRow(
              title: S.of(context).name,
              value: certificate.data.person.surnames +
                  ", " +
                  certificate.data.person.forenames,
              valueTextTheme: Theme.of(context).textTheme.subtitle2),
          Container(
            height: 20.0,
          ),
          CertRow(
            title: S.of(context).dateOfBirth,
            value: df.format(certificate.data.dateOfBirth),
          )
        ],
      ),
    );
  }
}
