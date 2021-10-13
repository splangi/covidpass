import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'generated/l10n.dart';

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
    if (!kIsWeb) {
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
    } else {
      return Container(
        color: Colors.black,
        child: const Center(
          child: Text(
            "Camera scanning not supported on Web",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }
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
              widget.onDetected(barcode.code);
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
