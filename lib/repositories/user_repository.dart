import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:ventureit/constants/firestore_constants.dart';
import 'package:ventureit/models/failure.dart';
import 'package:ventureit/models/user.dart';
import 'package:ventureit/providers/firebase_provider.dart';
import 'package:ventureit/type_defs.dart';

final userRepositoryProvider = Provider((ref) {
  return UserRepository(firestore: ref.watch(firestoreProvider));
});

class UserRepository {
  final FirebaseFirestore _firestore;

  UserRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _users =>
      _firestore.collection(FirestoreConstants.userCollection);

  Stream<UserModel> getUserData(id) {
    // TODO fix usermodel
    return _users.doc(id).snapshots().map((event) => UserModel(id: id));
  }

  FutureVoid addUser(UserModel user) async {
    try {
      return right(null);
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  FutureVoid updateUser(UserModel user) async {
    try {
      return right(null);
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }
}
