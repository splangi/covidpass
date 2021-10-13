import 'package:coronapass/cert_decoder.dart';
import 'package:coronapass/certificate.dart';
import 'package:coronapass/extensions/state_extensions.dart';
import 'package:coronapass/generated/l10n.dart';
import 'package:coronapass/loading_overlay.dart';
import 'package:coronapass/scanner_view.dart';
import 'package:coronapass/widget/simple_header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CodeScannerScreen extends StatelessWidget {
  static const routeName = "scan";

  const CodeScannerScreen({Key? key}) : super(key: key);

  static Route<Certificate> generateRoute(BuildContext context) {
    return CupertinoPageRoute(
        builder: (context) {
          return const CodeScannerScreen();
        },
        settings: const RouteSettings(name: routeName));
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      extendBodyBehindAppBar: true,
      body: ScannerScreenBody(),
    );
  }
}

class ScannerScreenBody extends StatefulWidget {
  const ScannerScreenBody({Key? key}) : super(key: key);

  @override
  _ScannerScreenBodyState createState() => _ScannerScreenBodyState();
}

class _ScannerScreenBodyState extends State<ScannerScreenBody> {
  bool loading = false;
  bool scanning = true;

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
        isLoading: loading,
        child: Stack(
          children: [
            ScannerView(
              onDetected: (code) => onCodeDetected(context, code),
              cutoutSize: 248.0,
              paused: loading,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Header(
                      padding: const EdgeInsets.only(
                          left: 6, right: 10.0, top: 20.0, bottom: 20.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: const Icon(
                                Icons.close,
                                color: Colors.white,
                              )),
                          Expanded(
                            child: Text(
                              S.of(context).scanCertificateQrCode,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }

  Future showErrorSnackBar(BuildContext context, Widget content,
      {SnackBarAction? action}) async {
    if (mounted) {
      late ScaffoldFeatureController controller;
      controller = ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: content,
        backgroundColor: Theme.of(context).errorColor,
        behavior: SnackBarBehavior.floating,
        action: action ??
            SnackBarAction(
                label: S.of(context).close,
                textColor: Colors.white,
                onPressed: () {
                  controller.close();
                }),
      ));
      await controller.closed;
    }
  }

  void onCodeDetected(BuildContext context, String code) async {
    if (scanning) {
      setState(() {
        loading = true;
        scanning = false;
      });
      if (code.startsWith("HC1:")) {
        try {
          final certificate = CertificateDecoder.decode(code);
          Navigator.of(context).pop(certificate);
        } on Exception {
          setState(() {
            loading = false;
          });
          await showErrorSnackBar(
              context, Text(S.of(context).failedToDecodeQrCode));
          safeSetState(() {
            scanning = true;
          });
        }
      } else {
        safeSetState(() {
          loading = false;
        });
        await showErrorSnackBar(context, Text(S.of(context).invalidQrCode));
        safeSetState(() {
          scanning = true;
        });
      }
    }
  }
}
