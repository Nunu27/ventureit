import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:ventureit/constants/firestore_constants.dart';
import 'package:ventureit/models/business/gallery_item.dart';
import 'package:ventureit/models/review.dart';
import 'package:ventureit/type_defs.dart';
import 'package:ventureit/utils/utils.dart';

class ReviewRepository {
  final FirebaseFirestore _firestore;

  ReviewRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _reviews =>
      _firestore.collection(FirestoreConstants.reviewCollection);

  Stream<List<Review>> getReviewsByBusinessId(String id, int page) {
    return _reviews
        .where('businessId', isEqualTo: id)
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
