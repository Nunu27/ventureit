import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ventureit/controllers/modal_controller.dart';
import 'package:ventureit/controllers/review_controller.dart';
import 'package:ventureit/models/review.dart';
import 'package:ventureit/widgets/cards/review_card.dart';
import 'package:ventureit/widgets/error_view.dart';
import 'package:ventureit/widgets/loader.dart';
import 'package:ventureit/widgets/rating.dart';

class ReviewsScreen extends ConsumerWidget {
  final String id;
  const ReviewsScreen({super.key, required this.id});

  void showReviewModal(
      BuildContext context, WidgetRef ref, Review? oldReview) async {
    await ref
        .read(modalControllerProvider)
        .showReviewModal(context, id, oldReview);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return ref.watch(getUserReviewProvider(id)).when(
          data: (myReview) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
            child: Column(children: [
              Expanded(
                child: ref.watch(getReviewsByBusinessIdProvider(id)).when(
                      data: (reviews) => myReview == null && reviews.isEmpty
                          ? const Center(child: Text('No reviews'))
                          : ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: myReview == null
                                  ? reviews.length
                                  : reviews.length + 1,
                              itemBuilder: (context, index) => myReview == null
                                  ? ReviewCard(review: reviews[index])
                                  : ReviewCard(
                                      review: index == 0
                                          ? myReview
                                          : reviews[index - 1]),
                            ),
                      error: (error, stackTrace) =>
                          ErrorView(error: error.toString()),
                      loading: () => const Loader(),
                    ),
              ),
              GestureDetector(
                onTap: () => showReviewModal(context, ref, myReview),
                behavior: HitTestBehavior.opaque,
                child: Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            myReview?.description ?? "Let's add a review here",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ),
                        if (myReview != null) Rating(myReview.rating),
                        Icon(
                          Icons.chevron_right,
                          color: theme.colorScheme.onPrimaryContainer,
                          size: 24,
                        ),
                      ],
                    )),
              )
            ]),
          ),
          error: (error, stackTrace) => ErrorView(error: error.toString()),
          loading: () => const Loader(),
        );
  }
}
