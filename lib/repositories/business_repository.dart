import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ventureit/constants/firestore_constants.dart';
import 'package:ventureit/providers/firebase_provider.dart';
import 'package:ventureit/repositories/storage_repository.dart';

final businessRepositoryProvider = Provider((ref) {
  return BusinessRepository(
    firestore: ref.watch(firestoreProvider),
    storageRepository: ref.watch(storageRepositoryProvider),
  );
});

class BusinessRepository {
  final FirebaseFirestore _firestore;
  final StorageRepository _storageRepository;

  BusinessRepository(
      {required FirebaseFirestore firestore,
      required StorageRepository storageRepository})
      : _firestore = firestore,
        _storageRepository = storageRepository;

  CollectionReference get _businesses =>
      _firestore.collection(FirestoreConstants.businessCollection);
}
