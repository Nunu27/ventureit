import 'package:flutter/material.dart';
import 'package:ventureit/models/business/business_content_item.dart';
import 'package:ventureit/utils/utils.dart';
import 'package:ventureit/widgets/remote_image.dart';

class ContentCard extends StatelessWidget {
  final BusinessContentItem content;
  const ContentCard({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: GestureDetector(
          onTap: () => openUrl(content.link),
          child: SizedBox(
            width: 138,
            height: 219,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: RemoteImage(
                    url: content.cover,
                    width: 138,
                    height: 219,
                    fit: BoxFit.cover,
                  ),
                )
              ],
            ),
          )),
    );
  }
}
