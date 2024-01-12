import 'package:flutter/material.dart';
import 'package:ventureit/widgets/loader.dart';

class LoaderOverlay extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  const LoaderOverlay({
    super.key,
    required this.child,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.black.withAlpha(150),
            ),
            child: const Loader(),
          )
      ],
    );
  }
}
