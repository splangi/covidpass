import 'dart:convert';
import 'dart:io';

import 'package:coronapass/certificate_storage.dart';
import 'package:coronapass/generated/l10n.dart';
import 'package:coronapass/model/vaccine_auth_holder.dart';
import 'package:coronapass/model/vaccine_product.dart';
import 'package:coronapass/model/vaccine_prophylaxis.dart';
import 'package:coronapass/model/valueset.dart';
import 'package:coronapass/screen/certificate_screen.dart';
import 'package:coronapass/screen/code_scanner_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  runApp(const ProviderWrapper(child: MyApp()));
}

ThemeData buildTheme() {
  const primaryColor = Color(0xFFFFE5BD);
  const background = Color(0xFFBDE7FF);

  return ThemeData(
      primaryColor: primaryColor,
      fontFamily: "FiraSans",
      outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
              elevation: 0.0,
              primary: Colors.black,
              side: const BorderSide(color: Colors.black, width: 1.0),
              shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ))),
      textTheme: Typography.englishLike2018.copyWith(
        overline: TextStyle(
            fontSize: 12.0,
            letterSpacing: 0.03,
            color: Colors.black.withOpacity(0.6)),
        caption: TextStyle(
            fontSize: 13.0,
            letterSpacing: 0.03,
            color: Colors.black.withOpacity(0.6)),
        button: const TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.03,
        ),
        bodyText2: const TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.03,
        ),
        bodyText1: const TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.03,
        ),
        subtitle2: const TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.03,
        ),
      ),
      cardTheme: CardTheme(
          elevation: 0.0,
          shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(100.0))));
}

class LocaleNotifier extends ChangeNotifier {

  static const localeKey = "locale";

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Locale _locale;

  Locale get locale => _locale;

  static Locale get _platformLocale => Locale(Platform.localeName.split("_").first);

  set locale(Locale locale) {
    _locale = locale;
    _saveToPrefs(locale);
    notifyListeners();
  }

  Future _saveToPrefs(Locale locale) async {
    (await _prefs).setString(localeKey, locale.languageCode);
  }

  Future _loadFromPrefs() async {
    final saved = (await _prefs).getString(localeKey);
    if (saved != null){
      locale = Locale(saved);
    }

  }

  LocaleNotifier() : _locale = _platformLocale{
    _loadFromPrefs();
  }
}

class ProviderWrapper extends StatelessWidget {
  final Widget child;

  const ProviderWrapper({Key? key, required this.child}) : super(key: key);

  Future<ValueSet<T>> fetchValueSet<T>(BuildContext context,
      String valueSetPath, T Function(Object) valueDecoder) async {
    final data = await DefaultAssetBundle.of(context).loadString(valueSetPath);
    final decodedData = jsonDecode(data);
    return ValueSet.fromJson(
        decodedData, (valueData) => valueDecoder(valueData!));
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LocaleNotifier>(
          create: (context) =>
              LocaleNotifier(),
        ),
        Provider<StringStorage>(
          create: (context) => SecureStorageStringStorage(),
        ),
        Provider<CertificateStorage>(
          create: (context) =>
              CertificateStorage(context.read<StringStorage>()),
        ),
        FutureProvider<ValueSet<VaccineAuthHolder>?>(
          create: (context) {
            return fetchValueSet(
                context,
                "ehn-dcc-schema/valuesets/vaccine-mah-manf.json",
                (p0) => VaccineAuthHolder.fromJson(p0 as Map<String, dynamic>));
          },
          lazy: false,
          initialData: null,
        ),
        FutureProvider<ValueSet<VaccineProduct>?>(
          create: (context) {
            return fetchValueSet(
                context,
                "ehn-dcc-schema/valuesets/vaccine-medicinal-product.json",
                (p0) => VaccineProduct.fromJson(p0 as Map<String, dynamic>));
          },
          lazy: false,
          initialData: null,
        ),
        FutureProvider<ValueSet<VaccineProphylaxis>?>(
          create: (context) {
            return fetchValueSet(
                context,
                "ehn-dcc-schema/valuesets/vaccine-prophylaxis.json",
                (p0) =>
                    VaccineProphylaxis.fromJson(p0 as Map<String, dynamic>));
          },
          lazy: false,
          initialData: null,
        )
      ],
      child: child,
    );
  }
}

class MyApp extends StatefulWidget {



  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {




  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "CovidPass",
      debugShowCheckedModeBanner: false,
      supportedLocales: S.delegate.supportedLocales,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        LocaleNamesLocalizationsDelegate(),
        S.delegate,
      ],
      routes: {
        CodeScannerScreen.routeName: (context) => const CodeScannerScreen(),
      },
      locale: context.watch<LocaleNotifier>().locale,
      theme: buildTheme(),
      home: const CertificateScreen(),
    );
  }
}
