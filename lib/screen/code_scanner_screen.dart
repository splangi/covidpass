import 'dart:async';

import 'package:coronapass/util/cert_decoder.dart';
import 'package:coronapass/model/certificate.dart';
import 'package:coronapass/extensions/state_extensions.dart';
import 'package:coronapass/generated/l10n.dart';
import 'package:coronapass/widget/loading_overlay.dart';
import 'package:coronapass/widget/simple_header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

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


class ScannerView extends StatefulWidget {
  final double cutoutSize;
  final Function(String) onDetected;
  final bool paused;

  const ScannerView(
      {Key? key,
        required this.onDetected,
        required this.cutoutSize,
        this.paused = false})
      : super(key: key);

  @override
  _ScannerViewState createState() => _ScannerViewState();
}

class _ScannerViewState extends State<ScannerView> with WidgetsBindingObserver {
  StreamSubscription<Barcode>? barcodeSubscription;

  final GlobalKey qrView = GlobalKey();

  Future<PermissionStatus>? cameraPermissionStatus;

  QRViewController? controller;

  @override
  void initState() {
    super.initState();
    setState(() {
      cameraPermissionStatus = !kIsWeb
          ? Permission.camera.status.then((value) =>
      value == PermissionStatus.granted
          ? Future.value(value)
          : Permission.camera.request())
          : Future.value(PermissionStatus.granted);
    });
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        setState(() {
          cameraPermissionStatus = !kIsWeb
              ? Permission.camera.status
              : Future.value(PermissionStatus.granted);
        });
        break;
      default:
      //Ignore
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: FutureBuilder<PermissionStatus>(
          future: cameraPermissionStatus,
          builder: (context, snapshot) {
            final status = snapshot.data;
            if (status == PermissionStatus.granted) {
              return buildQRScanner(context);
            } else if (status != null) {
              return buildAskPermissionView(context);
            } else {
              return Container(
                color: Colors.black,
              );
            }
          }),
    );
  }

  Widget buildAskPermissionView(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
            child: Text(S.of(context).allowCameraPermission),
            onPressed: () async {
              final timeA = DateTime.now().millisecondsSinceEpoch;
              setState(() {
                cameraPermissionStatus = Permission.camera.request();
              });
              var status = await cameraPermissionStatus;
              final timeB = DateTime.now().millisecondsSinceEpoch;
              //System automatically denied our request. Go to app settings page. [200ms is the limit of human reaction time, so there is slim chance that a human declined the request].
              if (status != PermissionStatus.granted && timeB - timeA < 200) {
                await openAppSettings();
              }
            },
          ),
          Text(
            S.of(context).cameraPermissionIsNeededToScanQrCode,
            style: Theme.of(context)
                .textTheme
                .caption!
                .copyWith(color: Colors.white38),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget buildQRScanner(BuildContext context) {
    return QRView(
        onQRViewCreated: (controller) async {
          setState(() {
            this.controller = controller;

            barcodeSubscription =
                controller.scannedDataStream.listen((barcode) {
                  final code = barcode.code;
                  if (code != null){
                    widget.onDetected(code);
                  }
                });
          });
          if (widget.paused) {
            await controller.pauseCamera();
          }
        },
        onPermissionSet: (controller, permission) {
          setState(() {});
        },
        overlayMargin: const EdgeInsets.all(200.0),
        key: qrView,
        cameraFacing: CameraFacing.back,
        overlay: QrScannerOverlayShape(
            cutOutSize: widget.cutoutSize,
            borderRadius: 12.0,
            borderColor: Colors.white,
            borderWidth: 4.0,
            overlayColor: Colors.black54));
  }

  @override
  void didUpdateWidget(covariant ScannerView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (controller != null && oldWidget.paused != widget.paused) {
      if (widget.paused) {
        controller?.pauseCamera();
      } else {
        controller?.resumeCamera();
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance?.removeObserver(this);
    barcodeSubscription?.cancel();
    controller?.dispose();
  }
}

