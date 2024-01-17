import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ventureit/models/business/business_content_item.dart';
import 'package:ventureit/widgets/cards/content_card.dart';

final dummyContents = <BusinessContentItem>[
  BusinessContentItem(
    cover:
        'https://p16-sign-va.tiktokcdn.com/obj/tos-maliva-p-0068/8b4b2f09a1c641cab28b46db40476ad1_1693058936?x-expires=1705413600&x-signature=KIKHCPlOj45aWBkSg%2BGSq4Fk39E%3D',
    link:
        'https://www.tiktok.com/@kulinermelintir/video/7271632703093542150?is_from_webapp=1&web_id=7317102299477198354',
    createdAt: '03/02/2021',
  )
];

class ContentsScreen extends ConsumerWidget {
  final String id;
  const ContentsScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.tiktok),
                    Text("Tiktok Review"),
                  ],
                ),
                Row(
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
                itemCount: 5,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return ContentCard(content: dummyContents[0]);
                },
              ),
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.facebook),
                    Text("Facebook Review"),
                  ],
                ),
                Row(
                  children: [
                    Text("ore"),
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
                itemCount: 5,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return ContentCard(content: dummyContents[0]);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
