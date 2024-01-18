import 'package:flutter/material.dart';
import 'package:ventureit/models/business/business_content_item.dart';
import 'package:ventureit/widgets/cards/content_card.dart';

class ContentView extends StatelessWidget {
  final Widget? icon;
  final String source;
  final List<BusinessContentItem> items;
  const ContentView(
      {super.key, this.icon, required this.source, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                if (icon != null) icon!,
                Text(source),
              ],
            ),
            const Row(
              children: [
                Text("More"),
                Icon(
                  Icons.navigate_next_rounded,
                )
              ],
            ),
          ],
        ),
        SizedBox(
          height: 219 + 8,
          width: double.infinity,
          child: ListView.builder(
            itemCount: items.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return ContentCard(content: items[index]);
            },
          ),
        ),
      ],
    );
  }
}
