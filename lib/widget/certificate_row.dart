


import 'package:flutter/material.dart';

class CertRow extends StatelessWidget {

  final String title;
  final String value;
  final TextStyle? valueTextTheme;

  const CertRow({Key? key, required this.title, required this.value, this.valueTextTheme}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title.toUpperCase(),
          style: Theme.of(context).textTheme.overline,
        ),
        Text(value,
            style: valueTextTheme ?? Theme.of(context).textTheme.bodyText1),
      ],
    );
  }



}