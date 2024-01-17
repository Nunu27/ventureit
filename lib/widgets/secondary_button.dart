import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  final Widget? child;
  final VoidCallback? onPressed;
  final double height;

  const SecondaryButton(
      {super.key, required this.onPressed, this.child, this.height = 40});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor: theme.colorScheme.onBackground,
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 1,
        ),
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
