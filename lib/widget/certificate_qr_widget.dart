import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CertificateQRWidget extends StatefulWidget {
  final String rawCertificate;
  final int errorCorretionLevel;

  const CertificateQRWidget(
      {Key? key,
      required this.rawCertificate,
      required this.errorCorretionLevel})
      : super(key: key);

  @override
  State<CertificateQRWidget> createState() => _CertificateQRWidgetState();
}

class _CertificateQRWidgetState extends State<CertificateQRWidget> {
  late QrCode qrCode;

  @override
  void initState() {
    super.initState();
    qrCode = QrCode.fromAlphaNumericData(
        alphaNumericData: widget.rawCertificate,
        errorCorrectLevel: widget.errorCorretionLevel);
  }

  @override
  void didUpdateWidget(covariant CertificateQRWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.rawCertificate != widget.rawCertificate ||
        oldWidget.errorCorretionLevel != widget.errorCorretionLevel) {
      qrCode = QrCode.fromAlphaNumericData(
          alphaNumericData: widget.rawCertificate,
          errorCorrectLevel: widget.errorCorretionLevel);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      alignment: Alignment.center,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: Hero(
          tag: widget.rawCertificate,
          child: QrWidget(
            key: ValueKey(qrCode),
            qr: qrCode,
            padding: EdgeInsets.zero,
          ),
        ),
      ),
    ));
  }
}
