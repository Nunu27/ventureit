import 'package:flutter/material.dart';
import 'package:ventureit/models/business/external_link.dart';

class ExternalLinkCard extends StatelessWidget {
  final ExternalLink externalLink;
  final Widget? trailing;

  const ExternalLinkCard({
    super.key,
    required this.externalLink,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          externalLink.site.logo,
          height: 24,
          width: 24,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            height: 36,
            margin: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
                color: theme.colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(18)),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    externalLink.url,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (trailing != null) trailing!
              ],
            ),
          ),
        ),
      ],
    );
  }
}
