import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:ventureit/constants/firestore_constants.dart';
import 'package:ventureit/models/business/gallery_item.dart';
import 'package:ventureit/models/review.dart';
import 'package:ventureit/providers/firebase_provider.dart';
import 'package:ventureit/type_defs.dart';
import 'package:ventureit/utils/utils.dart';

final reviewRepositoryProvider = Provider((ref) {
  return ReviewRepository(firestore: ref.watch(firestoreProvider));
});

class ReviewRepository {
  final FirebaseFirestore _firestore;

  ReviewRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _reviews =>
      _firestore.collection(FirestoreConstants.reviewCollection);

  Stream<Review?> getUserReview(String userId, String businessId) {
    return _reviews.doc(businessId + userId).snapshots().map(
      (event) {
        final data = event.data();
        return data == null
            ? null
            : Review.fromMap(data as Map<String, dynamic>);
      },
    );
  }

  Stream<List<Review>> getReviewsByBusinessId(
      String userId, String id, int page) {
    return _reviews
        .where('businessId', isEqualTo: id)
        .where('author.id', isNotEqualTo: userId)
        .orderBy('author.id')
        .orderBy('voteCount', descending: true)
        .limit(20)
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (e) => Review.fromMap(
                  e.data() as Map<String, dynamic>,
                ),
              )
              .toList(),
        );
  }

  Stream<List<GalleryItem>> getMediaByBusinessId(String id, int page) {
    return _reviews
        .where('businessId', isEqualTo: id)
        .where('mediaList', isNotEqualTo: [])
        .orderBy('mediaList')
        .orderBy('updatedAt', descending: true)
        .limit(20)
        .snapshots()
        .map(
          (event) {
            List<GalleryItem> results = [];

            for (var e in event.docs) {
              final review = Review.fromMap(e.data() as Map<String, dynamic>);

              results.addAll(review.toGalleryList());
            }

            return results;
          },
        );
  }

  FutureVoid upvote(String userId, Review review) async {
    try {
      return right(await _reviews.doc(review.id).update({
        'voteCount':
            FieldValue.increment(review.downvotes.contains(userId) ? 2 : 1),
        'upvotes': FieldValue.arrayUnion([userId]),
        'downvotes': FieldValue.arrayRemove([userId]),
      }));
    } catch (e) {
      return left(getError(e));
    }
  }

  FutureVoid unvote(String userId, Review review) async {
    try {
      return right(await _reviews.doc(review.id).update({
        'voteCount':
            FieldValue.increment(review.upvotes.contains(userId) ? -1 : 1),
        'upvotes': FieldValue.arrayRemove([userId]),
        'downvotes': FieldValue.arrayRemove([userId]),
      }));
    } catch (e) {
      return left(getError(e));
    }
  }

  FutureVoid downvote(String userId, Review review) async {
    try {
      return right(await _reviews.doc(review.id).update({
        'voteCount':
            FieldValue.increment(review.upvotes.contains(userId) ? -2 : -1),
        'upvotes': FieldValue.arrayRemove([userId]),
        'downvotes': FieldValue.arrayUnion([userId]),
      }));
    } catch (e) {
      return left(getError(e));
    }
  }

  FutureVoid saveReview(Review review) async {
    try {
      return right(await _reviews.doc(review.id).set(review.toMap()));
    } catch (e) {
      return left(getError(e));
    }
  }

  FutureVoid updateReview(Review review) async {
    try {
      return right(await _reviews.doc(review.id).update(review.updateMap()));
    } catch (e) {
      return left(getError(e));
    }
  }
}
