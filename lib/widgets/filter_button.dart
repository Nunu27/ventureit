import 'package:flutter/material.dart';

class FilterButton extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onPress;
  final IconData? icon;
  final double? iconSize;
  final Color? iconColor;
  final String? label;

  const FilterButton({
    super.key,
    this.isSelected = false,
    required this.onPress,
    this.icon,
    this.iconSize,
    this.iconColor,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: FittedBox(
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: isSelected
                ? theme.colorScheme.background
                : theme.colorScheme.onBackground,
            backgroundColor: isSelected ? theme.colorScheme.primary : null,
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 4,
            ),
          ),
          onPressed: onPress,
          child: Row(
            children: [
              if (icon != null)
                Icon(
                  icon,
                  size: iconSize,
                  color: iconColor,
                ),
              if (label != null && icon != null) const SizedBox(width: 5),
              if (label != null) Text(label!)
            ],
          ),
        ),
      ),
    );
  }
}
