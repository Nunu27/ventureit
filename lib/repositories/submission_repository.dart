import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:ventureit/constants/firestore_constants.dart';
import 'package:ventureit/models/submission/submission.dart';
import 'package:ventureit/providers/firebase_provider.dart';
import 'package:ventureit/repositories/storage_repository.dart';
import 'package:ventureit/type_defs.dart';
import 'package:ventureit/utils.dart';

final submissionRepositoryProvider = Provider((ref) {
  return SubmissionRepository(
    firestore: ref.watch(firestoreProvider),
    storageRepository: ref.watch(storageRepositoryProvider),
  );
});

class SubmissionRepository {
  final FirebaseFirestore _firestore;
  final StorageRepository _storageRepository;

  SubmissionRepository(
      {required FirebaseFirestore firestore,
      required StorageRepository storageRepository})
      : _firestore = firestore,
        _storageRepository = storageRepository;

  CollectionReference get _submissions =>
      _firestore.collection(FirestoreConstants.submissionCollection);

  FutureVoid submitSubmission({
    required Submission submission,
    required List<File?> pics,
  }) async {
    try {
      return right(null);
    } catch (e) {
      return left(getError(e));
    }
  }

  FutureVoid approveSubmission(String id) async {
    try {
      return right(null);
    } catch (e) {
      return left(getError(e));
    }
  }

  FutureVoid rejectSubmission(String id) async {
    try {
      return right(null);
    } catch (e) {
      return left(getError(e));
    }
  }
}
