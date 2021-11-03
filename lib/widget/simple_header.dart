import 'package:coronapass/widget/button_wrapper.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final EdgeInsets padding;
  final Widget child;

  const Header(
      {Key? key,
      required this.child,
      this.padding = const EdgeInsets.only(
          left: 30, right: 30.0, top: 20.0, bottom: 20.0)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: DefaultTextStyle(
        child: child,
        style: Theme.of(context).textTheme.headline6!,
      ),
    );
  }
}

class MainHeaderButton extends StatelessWidget {
  final Widget icon;
  final Widget label;
  final VoidCallback onTap;
  final Color? color;

  const MainHeaderButton(
      {Key? key,
      required this.icon,
      required this.label,
      required this.onTap,
      this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "main_header_button",
      child: DefaultButton(
        onTap: onTap,
        child: IntrinsicWidth(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              icon,
              Container(
                width: 10.0,
              ),
              Expanded(
                child: DefaultTextStyle(
                  child: label,
                  softWrap: false,
                  style: Theme.of(context)
                      .textTheme
                      .button!
                      .copyWith(color: color),
                  overflow: TextOverflow.clip,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
