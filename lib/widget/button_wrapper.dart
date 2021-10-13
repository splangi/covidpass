import 'package:flutter/material.dart';

class DefaultButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;

  const DefaultButton({Key? key, required this.onTap, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          child: ButtonDecoration(
            child: child,
          ),
        ));
  }
}

class ButtonDecoration extends StatelessWidget {
  final Widget child;

  const ButtonDecoration({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.0,
      decoration: BoxDecoration(
          border: Border.all(), borderRadius: BorderRadius.circular(4.0)),
      padding: const EdgeInsets.symmetric(
        horizontal: 10.0,
      ),
      alignment: Alignment.center,
      child: DefaultTextStyle(child: child, style: Theme.of(context).textTheme.button!,),
    );
  }
}
