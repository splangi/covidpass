// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `My Certificates`
  String get myCertificates {
    return Intl.message(
      'My Certificates',
      name: 'myCertificates',
      desc: '',
      args: [],
    );
  }

  /// `Vaccination`
  String get vaccination {
    return Intl.message(
      'Vaccination',
      name: 'vaccination',
      desc: '',
      args: [],
    );
  }

  /// `Recovery`
  String get recovery {
    return Intl.message(
      'Recovery',
      name: 'recovery',
      desc: '',
      args: [],
    );
  }

  /// `Test`
  String get test {
    return Intl.message(
      'Test',
      name: 'test',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get add {
    return Intl.message(
      'Add',
      name: 'add',
      desc: '',
      args: [],
    );
  }

  /// `Back`
  String get back {
    return Intl.message(
      'Back',
      name: 'back',
      desc: '',
      args: [],
    );
  }

  /// `Date of birth`
  String get dateOfBirth {
    return Intl.message(
      'Date of birth',
      name: 'dateOfBirth',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Negative`
  String get negative {
    return Intl.message(
      'Negative',
      name: 'negative',
      desc: '',
      args: [],
    );
  }

  /// `Positive`
  String get positive {
    return Intl.message(
      'Positive',
      name: 'positive',
      desc: '',
      args: [],
    );
  }

  /// `Nucleic Acid Amplification Test`
  String get nucleicAcidAmplificationTest {
    return Intl.message(
      'Nucleic Acid Amplification Test',
      name: 'nucleicAcidAmplificationTest',
      desc: '',
      args: [],
    );
  }

  /// `Rapid Antigen Test`
  String get rapidAntigenTest {
    return Intl.message(
      'Rapid Antigen Test',
      name: 'rapidAntigenTest',
      desc: '',
      args: [],
    );
  }

  /// `Sample collection time`
  String get sampleCollectionTime {
    return Intl.message(
      'Sample collection time',
      name: 'sampleCollectionTime',
      desc: '',
      args: [],
    );
  }

  /// `Test type`
  String get testType {
    return Intl.message(
      'Test type',
      name: 'testType',
      desc: '',
      args: [],
    );
  }

  /// `Test name`
  String get testName {
    return Intl.message(
      'Test name',
      name: 'testName',
      desc: '',
      args: [],
    );
  }

  /// `Testing centre`
  String get testingCentre {
    return Intl.message(
      'Testing centre',
      name: 'testingCentre',
      desc: '',
      args: [],
    );
  }

  /// `Issuer`
  String get issuer {
    return Intl.message(
      'Issuer',
      name: 'issuer',
      desc: '',
      args: [],
    );
  }

  /// `Country`
  String get country {
    return Intl.message(
      'Country',
      name: 'country',
      desc: '',
      args: [],
    );
  }

  /// `Valid from`
  String get validFrom {
    return Intl.message(
      'Valid from',
      name: 'validFrom',
      desc: '',
      args: [],
    );
  }

  /// `Valid until`
  String get validUntil {
    return Intl.message(
      'Valid until',
      name: 'validUntil',
      desc: '',
      args: [],
    );
  }

  /// `Date of positive result`
  String get dateOfPositiveResult {
    return Intl.message(
      'Date of positive result',
      name: 'dateOfPositiveResult',
      desc: '',
      args: [],
    );
  }

  /// `Date of vaccination`
  String get dateOfVaccination {
    return Intl.message(
      'Date of vaccination',
      name: 'dateOfVaccination',
      desc: '',
      args: [],
    );
  }

  /// `Doses`
  String get doses {
    return Intl.message(
      'Doses',
      name: 'doses',
      desc: '',
      args: [],
    );
  }

  /// `Vaccine`
  String get vaccine {
    return Intl.message(
      'Vaccine',
      name: 'vaccine',
      desc: '',
      args: [],
    );
  }

  /// `Authorization holder`
  String get authorizationHolder {
    return Intl.message(
      'Authorization holder',
      name: 'authorizationHolder',
      desc: '',
      args: [],
    );
  }

  /// `Vaccine type`
  String get vaccineType {
    return Intl.message(
      'Vaccine type',
      name: 'vaccineType',
      desc: '',
      args: [],
    );
  }

  /// `Vaccination country`
  String get vaccinationCountry {
    return Intl.message(
      'Vaccination country',
      name: 'vaccinationCountry',
      desc: '',
      args: [],
    );
  }

  /// `Result`
  String get result {
    return Intl.message(
      'Result',
      name: 'result',
      desc: '',
      args: [],
    );
  }

  /// `Scan Certificate QR code`
  String get scanCertificateQrCode {
    return Intl.message(
      'Scan Certificate QR code',
      name: 'scanCertificateQrCode',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get close {
    return Intl.message(
      'Close',
      name: 'close',
      desc: '',
      args: [],
    );
  }

  /// `Failed to decode QR code`
  String get failedToDecodeQrCode {
    return Intl.message(
      'Failed to decode QR code',
      name: 'failedToDecodeQrCode',
      desc: '',
      args: [],
    );
  }

  /// `Invalid QR Code`
  String get invalidQrCode {
    return Intl.message(
      'Invalid QR Code',
      name: 'invalidQrCode',
      desc: '',
      args: [],
    );
  }

  /// `Allow camera permission`
  String get allowCameraPermission {
    return Intl.message(
      'Allow camera permission',
      name: 'allowCameraPermission',
      desc: '',
      args: [],
    );
  }

  /// `Camera permission is needed to scan QR Code`
  String get cameraPermissionIsNeededToScanQrCode {
    return Intl.message(
      'Camera permission is needed to scan QR Code',
      name: 'cameraPermissionIsNeededToScanQrCode',
      desc: '',
      args: [],
    );
  }

  /// `Start by adding a certificate`
  String get startByAddingACertificate {
    return Intl.message(
      'Start by adding a certificate',
      name: 'startByAddingACertificate',
      desc: '',
      args: [],
    );
  }

  /// `Open`
  String get open {
    return Intl.message(
      'Open',
      name: 'open',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'bg'),
      Locale.fromSubtags(languageCode: 'cs'),
      Locale.fromSubtags(languageCode: 'da'),
      Locale.fromSubtags(languageCode: 'de'),
      Locale.fromSubtags(languageCode: 'el'),
      Locale.fromSubtags(languageCode: 'es'),
      Locale.fromSubtags(languageCode: 'et'),
      Locale.fromSubtags(languageCode: 'fi'),
      Locale.fromSubtags(languageCode: 'fr'),
      Locale.fromSubtags(languageCode: 'hu'),
      Locale.fromSubtags(languageCode: 'it'),
      Locale.fromSubtags(languageCode: 'lt'),
      Locale.fromSubtags(languageCode: 'lv'),
      Locale.fromSubtags(languageCode: 'nl'),
      Locale.fromSubtags(languageCode: 'pl'),
      Locale.fromSubtags(languageCode: 'pt'),
      Locale.fromSubtags(languageCode: 'ro'),
      Locale.fromSubtags(languageCode: 'ru'),
      Locale.fromSubtags(languageCode: 'sk'),
      Locale.fromSubtags(languageCode: 'sl'),
      Locale.fromSubtags(languageCode: 'sv'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
