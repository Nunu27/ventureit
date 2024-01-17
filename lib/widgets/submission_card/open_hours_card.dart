import 'package:flutter/material.dart';

class OpenHourCard extends StatelessWidget {
  final bool isOpen;
  final Widget? trailing;
  final String text;

  const OpenHourCard({
    super.key,
    this.isOpen = true,
    this.trailing,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 36,
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
          color: theme.colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(18)),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
      child: Row(
        children: [
          Text(
            isOpen ? 'Open' : 'Closed',
            style: TextStyle(
              fontSize: 12,
              color: isOpen ? Colors.green : Colors.red,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          if (trailing != null) trailing!
        ],
      ),
    );
  }
}
