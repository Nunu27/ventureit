import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ventureit/constants/constants.dart';
import 'package:ventureit/models/review.dart';
import 'package:ventureit/models/user_basic.dart';
import 'package:ventureit/widgets/remote_image.dart';

final dummyReviews = [
  Review(
    id: '',
    businessId: '',
    rating: 4,
    mediaList: [
      'https://p16-sign-va.tiktokcdn.com/obj/tos-maliva-p-0068/8b4b2f09a1c641cab28b46db40476ad1_1693058936?x-expires=1705413600&x-signature=KIKHCPlOj45aWBkSg%2BGSq4Fk39E%3D',
      'https://p16-sign-va.tiktokcdn.com/obj/tos-maliva-p-0068/8b4b2f09a1c641cab28b46db40476ad1_1693058936?x-expires=1705413600&x-signature=KIKHCPlOj45aWBkSg%2BGSq4Fk39E%3D',
      'https://p16-sign-va.tiktokcdn.com/obj/tos-maliva-p-0068/8b4b2f09a1c641cab28b46db40476ad1_1693058936?x-expires=1705413600&x-signature=KIKHCPlOj45aWBkSg%2BGSq4Fk39E%3D',
      'https://p16-sign-va.tiktokcdn.com/obj/tos-maliva-p-0068/8b4b2f09a1c641cab28b46db40476ad1_1693058936?x-expires=1705413600&x-signature=KIKHCPlOj45aWBkSg%2BGSq4Fk39E%3D',
      'https://p16-sign-va.tiktokcdn.com/obj/tos-maliva-p-0068/8b4b2f09a1c641cab28b46db40476ad1_1693058936?x-expires=1705413600&x-signature=KIKHCPlOj45aWBkSg%2BGSq4Fk39E%3D',
      'https://p16-sign-va.tiktokcdn.com/obj/tos-maliva-p-0068/8b4b2f09a1c641cab28b46db40476ad1_1693058936?x-expires=1705413600&x-signature=KIKHCPlOj45aWBkSg%2BGSq4Fk39E%3D',
      'https://p16-sign-va.tiktokcdn.com/obj/tos-maliva-p-0068/8b4b2f09a1c641cab28b46db40476ad1_1693058936?x-expires=1705413600&x-signature=KIKHCPlOj45aWBkSg%2BGSq4Fk39E%3D',
      'https://p16-sign-va.tiktokcdn.com/obj/tos-maliva-p-0068/8b4b2f09a1c641cab28b46db40476ad1_1693058936?x-expires=1705413600&x-signature=KIKHCPlOj45aWBkSg%2BGSq4Fk39E%3D',
      'https://p16-sign-va.tiktokcdn.com/obj/tos-maliva-p-0068/8b4b2f09a1c641cab28b46db40476ad1_1693058936?x-expires=1705413600&x-signature=KIKHCPlOj45aWBkSg%2BGSq4Fk39E%3D',
    ],
    description: 'Mantap bet',
    voteCount: 4,
    upvotes: [],
    downvotes: [],
    author: UserBasic(id: '', avatar: Constants.defaultAvatar, name: 'Fris'),
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  Review(
    id: '',
    businessId: '',
    rating: 4,
    mediaList: [],
    description: 'rill',
    voteCount: 4,
    upvotes: [],
    downvotes: [],
    author: UserBasic(id: '', avatar: Constants.defaultAvatar, name: 'Ana'),
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  )
];

class ReviewsScreen extends ConsumerWidget {
  final String id;
  const ReviewsScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Column(children: [
      Expanded(
        child: ListView.builder(
          itemCount: dummyReviews.length,
          itemBuilder: (context, index) {
            final review = dummyReviews[index];

            return Padding(
              padding: const EdgeInsets.all(18),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8)),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    height: 28,
                                    width: 28,
                                    child: CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(review.author.avatar),
                                      radius: 8,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    review.author.name,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color:
                                          theme.colorScheme.onPrimaryContainer,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    '3 days ago',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: theme
                                          .colorScheme.onPrimaryContainer
                                          .withAlpha(153),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 14,
                              ),
                              Text(
                                review.description,
                                style: TextStyle(
                                  color: theme.colorScheme.onPrimaryContainer,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            IconButton(
                              visualDensity: VisualDensity.compact,
                              onPressed: () {},
                              icon: Icon(
                                Icons.arrow_upward,
                                size: 24,
                                color: theme.colorScheme.onPrimaryContainer,
                              ),
                            ),
                            Text(
                              review.voteCount.toString(),
                              style: TextStyle(
                                fontSize: 12,
                                color: theme.colorScheme.onPrimaryContainer,
                              ),
                            ),
                            IconButton(
                              visualDensity: VisualDensity.compact,
                              onPressed: () {},
                              icon: Icon(
                                Icons.arrow_downward,
                                color: theme.colorScheme.onPrimaryContainer,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    if (review.mediaList.isNotEmpty)
                      SizedBox(
                        height: 99,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: review.mediaList.length,
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: RemoteImage(
                                url: review.mediaList[index],
                                height: 99,
                                width: 99,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.background,
        ),
        padding: EdgeInsets.all(18),
        child: TextField(
          decoration: InputDecoration(
            filled: true,
            hintText: "Let's add a review here",
            hintStyle: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.normal,
              color: theme.colorScheme.onPrimaryContainer,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            fillColor: theme.colorScheme.primaryContainer,
            isDense: true,
            suffixIcon: Icon(
              Icons.send,
              color: theme.colorScheme.onPrimaryContainer,
              size: 24,
            ),
          ),
        ),
      )
    ]);
  }
}
