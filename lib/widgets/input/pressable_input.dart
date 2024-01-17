import 'package:flutter/material.dart';

class CustomPressableInput extends StatelessWidget {
  final VoidCallback onPress;
  final String label;
  final double height;
  final Widget? child;
  final Widget? leading;
  final Widget? suffixIcon;
  final Widget? suffix;

  const CustomPressableInput({
    super.key,
    required this.onPress,
    required this.label,
    this.height = 36,
    this.child,
    this.leading,
    this.suffixIcon,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8),
          Container(
            height: height,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(18),
            ),
            child: GestureDetector(
              onTap: onPress,
              behavior: HitTestBehavior.opaque,
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        if (height == 36) const SizedBox(width: 18),
                        if (leading != null) leading!,
                        if (leading != null && child != null)
                          const SizedBox(width: 8),
                        if (child != null) Flexible(child: child!),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      if (suffixIcon != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          child: suffixIcon,
                        ),
                      if (suffix != null) suffix!,
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
