import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:ventureit/providers/firebase_provider.dart';
import 'package:ventureit/type_defs.dart';
import 'package:ventureit/utils/utils.dart';

final storageRepositoryProvider = Provider((ref) {
  return StorageRepository(storage: ref.watch(storageProvider));
});

class StorageRepository {
  final bool useFirebaseStorage;
  final FirebaseStorage _storage;

  StorageRepository(
      {required FirebaseStorage storage, this.useFirebaseStorage = true})
      : _storage = storage;

  FutureEither<String> storeFile({
    required String path,
    required String id,
    required File? file,
  }) async {
    try {
      final ref = _storage.ref().child(path).child(id);
      final snapshot = await ref.putFile(file!);

      return right(await snapshot.ref.getDownloadURL());
    } catch (e) {
      return left(getError(e));
    }
  }
}
