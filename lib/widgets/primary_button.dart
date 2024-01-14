import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final Widget? child;
  final VoidCallback? onPress;
  final double height;

  const PrimaryButton(
      {super.key, required this.onPress, this.child, this.height = 50});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        minimumSize: Size(double.infinity, height),
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 1,
        ),
      ),
      onPressed: onPress,
      child: child,
    );
  }
}
