import 'package:coronapass/model/certificate.dart';
import 'package:coronapass/util/certificate_storage.dart';
import 'package:coronapass/generated/l10n.dart';
import 'package:coronapass/screen/certificate_screen.dart';
import 'package:coronapass/widget/certificate_person.dart';
import 'package:coronapass/widget/certificate_qr_widget.dart';
import 'package:coronapass/widget/certification_type_info.dart';
import 'package:coronapass/widget/simple_header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CertificateDetailsScreen extends StatelessWidget {
  static const routeName = "details";

  static Route generateRoute(BuildContext context,
      {required Certificate certificate}) {
    return PageRouteBuilder(

        pageBuilder: (context, _, __) {
          return CertificateDetailsScreen(certificate: certificate);
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        settings: const RouteSettings(name: routeName));
  }

  final Certificate certificate;

  const CertificateDetailsScreen({Key? key, required this.certificate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
          child: SafeArea(
              minimum:
              const EdgeInsets.only(left: 30.0, right: 30.0, bottom: 30.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Header(
                      padding: const EdgeInsets.only(top: 20.0, bottom: 40.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MainHeaderButton(
                              icon: const Icon(Icons.arrow_back),
                              label: Text(S.of(context).back),
                              onTap: () async {
                                Navigator.of(context).pop();
                              }),
                          Expanded(
                            child: Container(),
                          ),
                          IconButton(
                            onPressed: () async {
                              await context
                                  .read<CertificateStorage>()
                                  .removeCertificate(certificate);
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(Icons.delete_forever_outlined),
                            color: Colors.redAccent,
                          )
                        ],
                      )),
                  CertificateDetailsBody(
                    certificate: certificate,
                  ),
                ],
              ))),
    );
  }
}

class CertificateDetailsBody extends StatelessWidget {
  final Certificate certificate;

  const CertificateDetailsBody({Key? key, required this.certificate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CertificateTitle(
          certificate: certificate,
        ),
        Text(
          certificate.data.identifier,
          style: Theme.of(context).textTheme.caption,
          overflow: TextOverflow.fade,
        ),
        Container(
          height: 20.0,
        ),
        CertificateQRWidget(
            rawCertificate: certificate.rawData,
            errorCorretionLevel: QrErrorCorrectLevel.L),
        Container(
          height: 20.0,
        ),
        CertificatePerson(
          certificate: certificate,
        ),
        Container(
          height: 20.0,
        ),
        CertificateInfo(
          certificateData: certificate.data,
        ),
      ],
      mainAxisSize: MainAxisSize.min,
    );
  }
}

class CertificateInfo extends StatelessWidget {
  final CertificateData certificateData;

  const CertificateInfo({Key? key, required this.certificateData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (certificateData.type) {
      case CertificateType.vaccination:
        return VaccinationInfo(
          certificate: certificateData.vaccinationCertificate!,
        );
      case CertificateType.recovery:
        return RecoveryInfo(certificate: certificateData.recoveryCertificate!);
      case CertificateType.test:
        return TestInfo(
          certificate: certificateData.testCertificate!,
        );
    }
  }
}
