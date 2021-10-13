import 'dart:convert';
import 'dart:developer';

import 'package:coronapass/cert_decoder.dart';
import 'package:coronapass/certificate.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rxdart/rxdart.dart';

class CertificateStorage {
  static const certificateKeys = "certs";

  final StringStorage storage;
  final BehaviorSubject<Future<List<Certificate>>> _certificates;

  CertificateStorage(this.storage)
      : _certificates = BehaviorSubject.seeded(_fetchCertificates(storage));

  static Future<List<Certificate>> _fetchCertificates(
      StringStorage storage) async {
    try {
      final encodedData = await storage.fetch(certificateKeys);
      if (encodedData == null) {
        return [];
      }
      final data = jsonDecode(encodedData) as List<dynamic>;
      return data
          .map((rawCertificate) => CertificateDecoder.decode(rawCertificate))
          .toList();
    } catch (err, stack) {
      log("Failed to fetch certificates", error: err, stackTrace: stack);
      return [];
    }
  }

  Stream<List<Certificate>> get certificates => _certificates.asyncMap((event) => event);

  Future saveCertificate(Certificate certificate) async {
    final certs = List.of(await _certificates.value);
    certs.remove(certificate);
    certs.insert(0, certificate);
    await storage.save(
        certificateKeys, jsonEncode(certs.map((e) => e.rawData).toList()));
    _certificates.value = Future.value(certs);
  }

  Future removeCertificate(Certificate certificate) async {
    final certs = List.of(await _certificates.value);
    certs.remove(certificate);
    await storage.save(certificateKeys, jsonEncode(certs.map((e) => e.rawData).toList()));
    _certificates.value = Future.value(certs);
  }
}

abstract class StringStorage {
  Future<String?> fetch(String key);

  Future<void> save(String key, String data);
}

class SecureStorageStringStorage implements StringStorage {
  final storage = const FlutterSecureStorage();

  @override
  Future<String?> fetch(String key) => storage.read(key: key);

  @override
  Future<void> save(String key, String data) =>
      storage.write(key: key, value: data);
}
