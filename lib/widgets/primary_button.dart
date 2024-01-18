import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final Widget? child;
  final VoidCallback? onPress;
  final double height;
  final Size? minimumSize;

  const PrimaryButton({
    super.key,
    required this.onPress,
    this.child,
    this.height = 40,
    this.minimumSize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        minimumSize: minimumSize,
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 8,
        ),
      ),
      onPressed: onPress,
      child: child,
    );
  }
}
