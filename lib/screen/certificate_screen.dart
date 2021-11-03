import 'package:coronapass/model/certificate.dart';
import 'package:coronapass/util/certificate_storage.dart';
import 'package:coronapass/generated/l10n.dart';
import 'package:coronapass/screen/certificate_details.dart';
import 'package:coronapass/screen/code_scanner_screen.dart';
import 'package:coronapass/widget/button_wrapper.dart';
import 'package:coronapass/widget/certificate_person.dart';
import 'package:coronapass/widget/certificate_qr_widget.dart';
import 'package:coronapass/widget/language_button.dart';
import 'package:coronapass/widget/simple_header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qr/qr.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:wakelock/wakelock.dart';

class CertificateScreen extends StatefulWidget {
  const CertificateScreen({Key? key}) : super(key: key);

  @override
  State<CertificateScreen> createState() => _CertificateScreenState();
}

class _CertificateScreenState extends State<CertificateScreen> {
  final controller = PageController(viewportFraction: 0.9);

  @override
  void initState() {
    super.initState();
    Wakelock.enable();
  }

  @override
  void dispose() {
    Wakelock.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFBDE7FF),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Header(
                padding: const EdgeInsets.only(
                    left: 30, right: 30.0, top: 20.0, bottom: 20.0),
                child: Row(
                  children: [
                    const LanguageButton(),
                    Expanded(
                      child: Container(),
                    ),
                    MainHeaderButton(
                        icon: const Icon(Icons.add),
                        label: Text(S.of(context).add),
                        onTap: navigateToScannerScreen)
                  ],
                )),

            Expanded(
                child: StreamBuilder<List<Certificate>>(
                    stream: context.read<CertificateStorage>().certificates,
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 30, right: 30.0, top: 20.0, bottom: 20.0),
                              child: Text(
                                S.of(context).myCertificates,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    ?.copyWith(fontWeight: FontWeight.w400),
                              ),
                            ),
                            Expanded(
                              child: PageView(
                                physics: const BouncingScrollPhysics(),
                                controller: controller,
                                children: snapshot.data!
                                    .map((e) => CertificateCard(certificate: e))
                                    .toList(),
                              ),
                            ),
                          ],
                        );
                      } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                        return emptyView();
                      }
                      return Container();
                    })),
          ],
        ),
      ),
    );
  }

  Widget emptyView() {
    return Center(
      child: Column(
        children: [
          GestureDetector(
            child: Image.asset(
              "assets/app_logo.png",
              width: 216.0,
              height: 216.0,
            ),
            onTap: navigateToScannerScreen,
          ),
          Container(
            height: 30.0,
          ),
          Text(
            S.of(context).startByAddingACertificate,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline6?.copyWith(fontWeight: FontWeight.w300),
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
      ),
    );
  }

  void navigateToScannerScreen()async {
    final certificate = await Navigator.of(context)
        .push(CodeScannerScreen.generateRoute(context));
    if (certificate != null) {
      await context
          .read<CertificateStorage>()
          .saveCertificate(certificate);
      controller.animateToPage(0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut);
    }
  }


}

class CertificateCard extends StatelessWidget {
  final Certificate certificate;
  final DateFormat df = DateFormat("dd.MM.yyyy");
  final DateFormat dfTest = DateFormat("dd.MM.yyyy HH:mm");

  CertificateCard({Key? key, required this.certificate}) : super(key: key);

  void navigateToDetails(BuildContext context){
    Navigator.of(context).push(CertificateDetailsScreen.generateRoute(
        context,
        certificate: certificate));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.all(8.0),
      child: Material(
          borderRadius: BorderRadius.circular(10.0),
          elevation: 0.0,
          child: InkWell(
            onTap: () => navigateToDetails(context),
            child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                CertificateTitle(
                                  certificate: certificate,
                                ),
                                certificateSubtitle(context, certificate),

                              ],
                            ),
                          ),
                          DefaultButton(onTap: () => navigateToDetails(context), child: Text(S.of(context).open))
                        ],
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
                      )
                    ])),
          )),
    );
  }

  Widget certificateSubtitle(BuildContext context, Certificate certificate) {
    String subtitle;
    switch (certificate.data.type) {
      case CertificateType.vaccination:
        final vaccinationData = certificate.data.vaccinationCertificate!;
        subtitle =
            "${df.format(vaccinationData.dateOfVaccination)} (${vaccinationData.doses}/${vaccinationData.overallDoses})";
        break;
      case CertificateType.recovery:
        final recoveryData = certificate.data.recoveryCertificate!;
        subtitle =
            "${df.format(recoveryData.validFrom)} - ${df.format(recoveryData.validUntil)}";
        break;
      case CertificateType.test:
        final testData = certificate.data.testCertificate!;
        subtitle = dfTest.format(testData.testSampleCollectionTime);
        break;
    }
    return Text(
      subtitle,
      style: Theme.of(context).textTheme.caption,
      overflow: TextOverflow.fade,
    );
  }
}

class CertificateTitle extends StatelessWidget {
  final Certificate certificate;

  final DateFormat df = DateFormat("dd.MM.yyyy");
  final DateFormat dfTest = DateFormat("dd.MM.yyyy HH:mm");

  CertificateTitle({Key? key, required this.certificate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String title;

    switch (certificate.data.type) {
      case CertificateType.vaccination:
        title = S.of(context).vaccination;
        break;
      case CertificateType.recovery:
        title = S.of(context).recovery;
        break;
      case CertificateType.test:
        title = S.of(context).test;
        break;
    }

    return Hero(
      tag: certificate.rawData + "_title",
      child: Text(
        title,
        style: Theme.of(context).textTheme.headline6,
      ),
    );
  }
}
