import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:ventureit/constants/firestore_constants.dart';
import 'package:ventureit/models/user.dart';
import 'package:ventureit/models/user_basic.dart';
import 'package:ventureit/providers/firebase_provider.dart';
import 'package:ventureit/type_defs.dart';
import 'package:ventureit/utils/utils.dart';

final userRepositoryProvider = Provider((ref) {
  return UserRepository(firestore: ref.watch(firestoreProvider));
});

class UserRepository {
  final FirebaseFirestore _firestore;

  UserRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _users =>
      _firestore.collection(FirestoreConstants.userCollection);

  CollectionReference get _reviews =>
      _firestore.collection(FirestoreConstants.reviewCollection);

  Stream<UserModel?> getUserData(id) {
    return _users.doc(id).snapshots().map(
      (event) {
        final data = event.data();
        return data == null
            ? null
            : UserModel.fromMap(data as Map<String, dynamic>);
      },
    );
  }

  FutureVoid saveUser(UserModel user) async {
    try {
      return right(await _users.doc(user.id).set(user.toMap()));
    } catch (e) {
      return left(getError(e));
    }
  }

  FutureVoid updateUser(UserModel user) async {
    try {
      final batch = _firestore.batch();

      batch.update(_users.doc(user.id), user.updateMap());

      final reviews =
          await _reviews.where('author.id', isEqualTo: user.id).get();
      for (var e in reviews.docs) {
        batch.update(e.reference, {'author': UserBasic.fromUser(user).toMap()});
      }

      return right(await batch.commit());
    } catch (e) {
      return left(getError(e));
    }
  }

  FutureEither<int> getUserCount() async {
    try {
      final res = await _users.count().get();
      return right(res.count!);
    } catch (e) {
      return left(getError(e));
    }
  }
}
