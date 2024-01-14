import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:ventureit/constants/firestore_constants.dart';
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
      // TODO update business data based on submission

      return right(_submissions.doc(submission.id).update({
        'status': SubmissionStatus.approved,
      }));
    } catch (e) {
      return left(getError(e));
    }
  }

  FutureVoid rejectSubmission(Submission submission) async {
    try {
      return right(_submissions.doc(submission.id).update({
        'status': SubmissionStatus.rejected,
      }));
    } catch (e) {
      return left(getError(e));
    }
  }
}
