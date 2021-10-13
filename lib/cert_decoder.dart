import 'dart:io';

import 'package:cbor/cbor.dart';
import 'package:coronapass/certificate.dart';
import 'package:dart_base45/dart_base45.dart';

class CertificateDecoder {

  CertificateDecoder._();

  static Certificate decode(String rawData){
    final b45data = rawData.toString().substring(4);
    final zlibData = Base45.decode(b45data);
    final payload = ZLibDecoder().convert(zlibData);
    final cbor = Cbor();
    cbor.decodeFromList(payload);
    var cborData = cbor.getDecodedData()![0][2];
    var cbor2 = Cbor();
    cbor2.decodeFromList(cborData);
    final json = cbor2.getDecodedData()![0][-260][1];
    final castMap =
    (json as Map).map((key, value) => MapEntry(key as String, value));
    final certificate = Certificate(CertificateData.fromJson(castMap), rawData);
    return certificate;
  }

}