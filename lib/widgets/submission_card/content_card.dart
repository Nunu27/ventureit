import 'package:flutter/material.dart';
import 'package:ventureit/models/business/business_content_item.dart';
import 'package:ventureit/widgets/remote_image.dart';

class SubmissionContentCard extends StatelessWidget {
  final BusinessContentItem content;
  final Widget? trailing;

  const SubmissionContentCard({
    super.key,
    required this.content,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
          color: theme.colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(18)),
      child: Row(
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: RemoteImage(
                url: content.cover,
                height: 70,
                width: 70,
                fit: BoxFit.cover,
              )),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('TikTok'),
                  Text(
                    content.link,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          if (trailing != null) trailing!
        ],
      ),
    );
  }
}
