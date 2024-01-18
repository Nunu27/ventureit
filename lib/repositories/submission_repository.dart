import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:ventureit/constants/firestore_constants.dart';
import 'package:ventureit/models/business/business.dart';
import 'package:ventureit/models/submission/add_submission.dart';
import 'package:ventureit/models/submission/edit_submission.dart';
import 'package:ventureit/models/submission/entry_submission.dart';
import 'package:ventureit/models/submission/remove_submission.dart';
import 'package:ventureit/models/submission/submission.dart';
import 'package:ventureit/providers/firebase_provider.dart';
import 'package:ventureit/type_defs.dart';
import 'package:ventureit/utils/utils.dart';

final submissionRepositoryProvider = Provider((ref) {
  return SubmissionRepository(firestore: ref.watch(firestoreProvider));
});

class SubmissionRepository {
  final FirebaseFirestore _firestore;

  SubmissionRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _submissions =>
      _firestore.collection(FirestoreConstants.submissionCollection);
  CollectionReference get _businesses =>
      _firestore.collection(FirestoreConstants.businessCollection);

  Stream<List<Submission>> getPendingSubmissions() {
    return _submissions
        .where('status', isEqualTo: 'pending')
        .limit(20)
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (e) => Submission.fromMap(
                  e.data() as Map<String, dynamic>,
                ),
              )
              .toList(),
        );
  }

  Stream<List<Submission>> getSubmissionByUserId(String id) {
    return _submissions
        .where('userId', isEqualTo: id)
        .orderBy('createdAt', descending: true)
        .limit(20)
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (e) => Submission.fromMap(
                  e.data() as Map<String, dynamic>,
                ),
              )
              .toList(),
        );
  }

  Stream<Submission> getSubmissionById(String id) {
    return _submissions.doc(id).snapshots().map(
          (event) => Submission.fromMap(
            event.data() as Map<String, dynamic>,
          ),
        );
  }

  FutureVoid submitSubmission(Submission submission) async {
    try {
      return right(_submissions.doc(submission.id).set(submission.toMap()));
    } catch (e) {
      return left(getError(e));
    }
  }

  FutureVoid approveSubmission(Submission submission) async {
    try {
      final batch = _firestore.batch();
      final businessId = submission.businessId;
      final updateMap = <String, dynamic>{};

      for (var entry in submission.data) {
        if (entry is EntrySubmission) {
          final business = Business.fromEntry(entry);
          batch.set(_businesses.doc(business.id), business.toMap());
        } else if (entry is AddSubmission) {
          updateMap[entry.key] = FieldValue.arrayUnion(entry.value);
        } else if (entry is EditSubmission) {
          updateMap[entry.key] = entry.value;
        } else if (entry is RemoveSubmission) {
          updateMap[entry.key] = FieldValue.arrayRemove(entry.value);
        }
      }

      if (updateMap.isNotEmpty) {
        batch.update(_businesses.doc(businessId), updateMap);
      }

      batch.update(_submissions.doc(submission.id), {
        'businessId': businessId,
        'status': SubmissionStatus.approved.name,
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      });

      return right(await batch.commit());
    } catch (e) {
      return left(getError(e));
    }
  }

  FutureVoid rejectSubmission(Submission submission) async {
    try {
      return right(_submissions.doc(submission.id).update({
        'status': SubmissionStatus.rejected.name,
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      }));
    } catch (e) {
      return left(getError(e));
    }
  }
}
