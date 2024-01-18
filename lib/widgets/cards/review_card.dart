import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swipe_image_gallery/swipe_image_gallery.dart';
import 'package:ventureit/controllers/auth_controller.dart';
import 'package:ventureit/controllers/review_controller.dart';
import 'package:ventureit/models/review.dart';
import 'package:ventureit/widgets/rating.dart';
import 'package:ventureit/widgets/remote_image.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:ventureit/widgets/title_overlay.dart';

class ReviewCard extends ConsumerStatefulWidget {
  final Review review;
  const ReviewCard({super.key, required this.review});

  @override
  ConsumerState<ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends ConsumerState<ReviewCard> {
  StreamController<Widget> overlayController =
      StreamController<Widget>.broadcast();

  @override
  void dispose() {
    overlayController.close();
    super.dispose();
  }

  void upvote() {
    ref.read(reviewControllerProvider.notifier).upvote(widget.review);
  }

  void unvote() {
    ref.read(reviewControllerProvider.notifier).unvote(widget.review);
  }

  void downvote() {
    ref.read(reviewControllerProvider.notifier).downvote(widget.review);
  }

  void showGallery(int index) {
    SwipeImageGallery(
      context: context,
      initialIndex: index,
      overlayController: overlayController,
      itemBuilder: (context, index) =>
          RemoteImage(url: widget.review.mediaList[index]),
      itemCount: widget.review.mediaList.length,
      onSwipe: (index) {
        overlayController.add(TitleOverlay(
          title: '${index + 1}/${widget.review.mediaList.length}',
        ));
      },
      initialOverlay: TitleOverlay(
        title: '${index + 1}/${widget.review.mediaList.length}',
      ),
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    final userId = ref.watch(userProvider)?.id;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(18),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
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
                                  NetworkImage(widget.review.author.avatar),
                              radius: 8,
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.review.author.name,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: theme.colorScheme.onPrimaryContainer,
                                ),
                              ),
                              Row(
                                children: [
                                  Rating(widget.review.rating),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    timeago.format(widget.review.updatedAt),
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: theme
                                          .colorScheme.onPrimaryContainer
                                          .withAlpha(153),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 14,
                      ),
                      Text(
                        widget.review.description!,
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
                      onPressed: widget.review.upvotes.contains(userId)
                          ? unvote
                          : upvote,
                      iconSize: 24,
                      icon: Icon(
                        Icons.arrow_upward,
                        color: widget.review.upvotes.contains(userId)
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                    Text(
                      widget.review.voteCount.toString(),
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      onPressed: widget.review.downvotes.contains(userId)
                          ? unvote
                          : downvote,
                      iconSize: 24,
                      icon: Icon(
                        Icons.arrow_downward,
                        color: widget.review.downvotes.contains(userId)
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onPrimaryContainer,
                      ),
                    )
                  ],
                )
              ],
            ),
            if (widget.review.mediaList.isNotEmpty)
              SizedBox(
                height: 99,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.review.mediaList.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: GestureDetector(
                      onTap: () => showGallery(index),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: RemoteImage(
                          url: widget.review.mediaList[index],
                          height: 99,
                          width: 99,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
