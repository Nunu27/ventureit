import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ventureit/controllers/review_controller.dart';
import 'package:ventureit/models/review.dart';
import 'package:ventureit/utils/picker.dart';

class ReviewModal extends ConsumerStatefulWidget {
  final Review? review;
  final String businessId;
  const ReviewModal({super.key, required this.businessId, this.review});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ReviewModalState();
}

class _ReviewModalState extends ConsumerState<ReviewModal> {
  late TextEditingController reviewController;
  late double rating;
  List<File?> media = [];

  @override
  void initState() {
    super.initState();
    reviewController = TextEditingController(text: widget.review?.description);
    rating = widget.review?.rating ?? 3;
  }

  @override
  void dispose() {
    reviewController.dispose();
    super.dispose();
  }

  void selectMedia() async {
    final res = await pickMedia();
    if (res != null) {
      media = res.files.map((e) => File(e.path!)).toList();
      setState(() {});
    }
  }

  void post() {
    if (widget.review == null) {
      ref.read(reviewControllerProvider.notifier).saveReview(
            context: context,
            businessId: widget.businessId,
            rating: rating,
            description: reviewController.text.isEmpty
                ? null
                : reviewController.text.trim(),
            media: media,
          );
    } else {
      ref.read(reviewControllerProvider.notifier).updateReview(
            context: context,
            review: widget.review!.copyWith(
              rating: rating,
              description: reviewController.text.isEmpty
                  ? null
                  : reviewController.text.trim(),
            ),
            media: media,
          );
    }
    Navigator.of(context, rootNavigator: true).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Review this place',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: post,
                style: TextButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Post'),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Center(
            child: RatingBar.builder(
              initialRating: rating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 5.0),
              wrapAlignment: WrapAlignment.spaceEvenly,
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (newRating) {
                setState(() {
                  rating = newRating;
                });
              },
            ),
          ),
          const SizedBox(height: 18),
          if (media.isNotEmpty)
            Text(
              '${media.length} media attached',
              style: const TextStyle(fontSize: 12),
            ),
          TextField(
            controller: reviewController,
            autofocus: true,
            maxLines: 5,
            maxLength: 500,
            decoration: InputDecoration(
              filled: true,
              hintText: "Let's add a review here (optional)",
              hintStyle: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.onPrimaryContainer,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
              fillColor: theme.colorScheme.primaryContainer,
              isDense: true,
              suffixIcon: GestureDetector(
                onTap: selectMedia,
                child: Icon(
                  Icons.image,
                  color: theme.colorScheme.onPrimaryContainer,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
