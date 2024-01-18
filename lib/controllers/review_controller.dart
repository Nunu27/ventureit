import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ventureit/controllers/auth_controller.dart';
import 'package:ventureit/models/business/gallery_item.dart';
import 'package:ventureit/models/review.dart';
import 'package:ventureit/models/user_basic.dart';
import 'package:ventureit/repositories/review_repository.dart';
import 'package:ventureit/repositories/storage_repository.dart';
import 'package:ventureit/utils/utils.dart';

final reviewControllerProvider =
    StateNotifierProvider<ReviewController, bool>((ref) {
  return ReviewController(
    repository: ref.watch(reviewRepositoryProvider),
    storageRepository: ref.watch(storageRepositoryProvider),
    ref: ref,
  );
});

final getUserReviewProvider = StreamProvider.family((ref, String businessId) {
  return ref
      .watch(reviewControllerProvider.notifier)
      .getUserReview(ref.watch(userProvider)?.id ?? '', businessId);
});

final getReviewsByBusinessIdProvider =
    StreamProvider.family((ref, String businessId) {
  return ref
      .watch(reviewControllerProvider.notifier)
      .getReviewsByBusinessId(ref.watch(userProvider)?.id ?? '', businessId);
});

final getMediaByBusinessIdProvider =
    StreamProvider.family((ref, String businessId) {
  return ref
      .watch(reviewControllerProvider.notifier)
      .getMediaByBusinessId(businessId);
});

class ReviewController extends StateNotifier<bool> {
  final ReviewRepository _repository;
  final StorageRepository _storageRepository;
  final Ref _ref;

  ReviewController({
    required ReviewRepository repository,
    required StorageRepository storageRepository,
    required Ref ref,
  })  : _repository = repository,
        _storageRepository = storageRepository,
        _ref = ref,
        super(false);

  Stream<Review?> getUserReview(String userId, String businessId) {
    return _repository.getUserReview(userId, businessId);
  }

  Stream<List<Review>> getReviewsByBusinessId(String userId, String id) {
    return _repository.getReviewsByBusinessId(
      userId,
      id,
      0,
    );
  }

  Stream<List<GalleryItem>> getMediaByBusinessId(String id) {
    return _repository.getMediaByBusinessId(id, 0);
  }

  void saveReview({
    required BuildContext context,
    required String businessId,
    required double rating,
    String? description,
    List<File?> media = const [],
  }) async {
    final author = UserBasic.fromUser(_ref.read(userProvider)!);
    final id = businessId + author.id;
    state = true;
    List<String> mediaList = [];

    for (var entry in media) {
      final res = await _storageRepository.storeFile(
        path: '/images/reviews',
        id: id,
        file: entry,
      );

      final success = res.fold(
        (l) {
          showSnackBar(l.message);
          return false;
        },
        (r) {
          mediaList.add(r);
          return true;
        },
      );

      if (!success) return;
    }

    final result = await _repository.saveReview(
      Review(
        id: id,
        businessId: businessId,
        rating: rating,
        mediaList: mediaList,
        description: description,
        voteCount: 0,
        upvotes: [],
        downvotes: [],
        author: author,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
    state = false;

    result.fold((l) => showSnackBar(l.message), (r) {});
  }

  void updateReview({
    required BuildContext context,
    required Review review,
    List<File?> media = const [],
  }) async {
    final id = review.id;
    state = true;
    List<String> mediaList = [];

    for (var entry in media) {
      final res = await _storageRepository.storeFile(
        path: '/images/reviews',
        id: id,
        file: entry,
      );

      final success = res.fold(
        (l) {
          showSnackBar(l.message);
          return false;
        },
        (r) {
          mediaList.add(r);
          return true;
        },
      );

      if (!success) return;
    }
    if (mediaList.isNotEmpty) review = review.copyWith(mediaList: mediaList);

    final result = await _repository.updateReview(review);
    state = false;

    result.fold((l) => showSnackBar(l.message), (r) {});
  }

  void upvote(Review review) async {
    final userId = _ref.read(userProvider)?.id;
    if (userId == null) {
      showSnackBar("Please login to do voting.");
      return;
    }

    state = true;
    final result = await _repository.upvote(userId, review);
    state = false;

    result.fold((l) => showSnackBar(l.message), (r) {});
  }

  void unvote(Review review) async {
    final userId = _ref.read(userProvider)?.id;
    if (userId == null) {
      showSnackBar("Please login to do voting.");
      return;
    }

    state = true;
    final result = await _repository.unvote(userId, review);
    state = false;

    result.fold((l) => showSnackBar(l.message), (r) {});
  }

  void downvote(Review review) async {
    final userId = _ref.read(userProvider)?.id;
    if (userId == null) {
      showSnackBar("Please login to do voting.");
      return;
    }

    state = true;
    final result = await _repository.downvote(userId, review);
    state = false;

    result.fold((l) => showSnackBar(l.message), (r) {});
  }
}
