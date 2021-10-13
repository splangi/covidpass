import 'package:coronapass/generated/l10n.dart';
import 'package:coronapass/main.dart';
import 'package:coronapass/widget/button_wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:provider/provider.dart';

class LanguageButton extends StatefulWidget {
  const LanguageButton({Key? key}) : super(key: key);

  @override
  State<LanguageButton> createState() => _LanguageButtonState();
}

class _LanguageButtonState extends State<LanguageButton> {
  @override
  Widget build(BuildContext context) {
    final value = Localizations.localeOf(context);

    return ButtonDecoration(
      child: PopupMenuButton<Locale>(

        itemBuilder: (context) => S.delegate.supportedLocales.map((locale) {
      return PopupMenuItem(
        child: Text(LocaleNames.of(context)!.nameOf(locale.languageCode)!),
        value: locale,
      );
        }).toList(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(LocaleNames.of(context)!.nameOf(value.languageCode) ?? value.languageCode, style: Theme.of(context).textTheme.button,),
            Container(width: 5.0,),
            const Icon(Icons.keyboard_arrow_down)
          ],
        ),
        onSelected: (locale) => context.read<LocaleNotifier>().locale = locale,
      ),
    );
  }
}
