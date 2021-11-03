import 'package:flutter/material.dart';

class LoaderOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;

  const LoaderOverlay({Key? key, this.isLoading = false, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.loose,
      children: [
        child,
        if (isLoading)
          Positioned.fill(
            child: Container(
              color: Colors.black12,
            ),
          ),
        if (isLoading)
          const Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }
}
