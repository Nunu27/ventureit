import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:ventureit/constants/algolia_constants.dart';
import 'package:ventureit/constants/firestore_constants.dart';
import 'package:ventureit/models/base_position.dart';
import 'package:ventureit/models/mission.dart';
import 'package:ventureit/models/review.dart';
import 'package:ventureit/models/user.dart';
import 'package:ventureit/providers/algolia_provider.dart';
import 'package:ventureit/providers/firebase_provider.dart';
import 'package:ventureit/type_defs.dart';
import 'package:ventureit/utils/utils.dart';

final missionRepositoryProvider = Provider((ref) {
  return MissionRepository(
    firestore: ref.watch(firestoreProvider),
    algolia: ref.watch(algoliaProvider),
  );
});

class MissionRepository {
  final FirebaseFirestore _firestore;
  final Algolia _algolia;

  MissionRepository(
      {required FirebaseFirestore firestore, required Algolia algolia})
      : _firestore = firestore,
        _algolia = algolia;

  CollectionReference get _missions =>
      _firestore.collection(FirestoreConstants.missionCollection);
  CollectionReference get _users =>
      _firestore.collection(FirestoreConstants.userCollection);
  CollectionReference get _reviews =>
      _firestore.collection(FirestoreConstants.reviewCollection);
  CollectionReference get _submissions =>
      _firestore.collection(FirestoreConstants.submissionCollection);

  FutureEither<UserModel> save(UserModel user, List<Mission> missions) async {
    try {
      final batch = _firestore.batch();
      int totalCost = 0;

      for (var mission in missions) {
        batch.set(_missions.doc(mission.id), mission.toMap());
        totalCost += mission.type.reward * mission.maxQuota;
      }

      if (user.balance < totalCost) throw 'Balance insufficient';

      batch.update(
        _users.doc(user.id),
        {'balance': FieldValue.increment(-totalCost)},
      );

      await batch.commit();

      return right(user.copyWith(balance: user.balance - totalCost));
    } catch (e) {
      return left(getError(e));
    }
  }

  Stream<List<Mission>> fetchMissionByBusinessesId(List<String> businessesId) {
    return _missions
        .where('businessId', whereIn: businessesId)
        .limit(10)
        .snapshots()
        .map(
          (event) => event.docs
              .map((e) => Mission.fromMap(e.data() as Map<String, dynamic>))
              .toList(),
        );
  }

  FutureEither<List<String>> getBusinessWithMission(
      BasePosition position) async {
    try {
      AlgoliaQuery query = _algolia
          .index(AlgoliaConstants.businessIndex)
          .filters('haveMission: true')
          .setAroundLatLng('${position.latitude}, ${position.longitude}')
          .setAroundRadius(10000)
          .setLength(10);

      final snapshot = await query.getObjects();
      return right(
          snapshot.hits.map((e) => e.data['objectID'] as String).toList());
    } catch (e) {
      return left(getError(e));
    }
  }

  FutureEither<UserModel> claim(UserModel user, Mission mission) async {
    try {
      if (mission.finishedCount >= mission.maxQuota ||
          mission.claimedBy.contains(user.id)) throw 'Not eligible';

      if (mission.type == MissionType.review) {
        final snapshot = await _reviews.doc(mission.businessId + user.id).get();

        if (!snapshot.exists) throw 'Not eligible';
        final review = Review.fromMap(snapshot.data() as Map<String, dynamic>);
        if (review.updatedAt.compareTo(mission.createdAt) < 0) {
          throw 'Not eligble';
        }
      } else if (mission.type == MissionType.contribute) {
        final snapshot = await _submissions
            .where('userId', isEqualTo: user.id)
            .where('businessId', isEqualTo: mission.businessId)
            .where('status', isEqualTo: 'approve')
            .where(
              'createdAt',
              isGreaterThanOrEqualTo: mission.createdAt.millisecondsSinceEpoch,
            )
            .limit(1)
            .get();

        if (snapshot.docs.isEmpty) throw 'Not eligible';
      }

      final batch = _firestore.batch();

      batch.update(
        _missions.doc(mission.id),
        {
          'claimedBy': FieldValue.arrayUnion([user.id]),
          'finishedCount': FieldValue.increment(1),
          'updatedAt': DateTime.now().millisecondsSinceEpoch
        },
      );
      batch.update(
        _users.doc(user.id),
        {'balance': FieldValue.increment(mission.type.reward)},
      );
      await batch.commit();

      return right(user.copyWith(balance: user.balance + mission.type.reward));
    } catch (e) {
      return left(getError(e));
    }
  }
}
