import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ventureit/constants/constants.dart';
import 'package:ventureit/models/user.dart';
import 'package:ventureit/providers/firebase_provider.dart';
import 'package:ventureit/repositories/user_repository.dart';
import 'package:ventureit/type_defs.dart';
import 'package:ventureit/utils.dart';

final authRepositoryProvider = Provider((ref) {
  return AuthRepository(
    auth: ref.watch(authProvider),
    googleSignIn: ref.watch(googleSignInProvider),
    userRepository: ref.watch(userRepositoryProvider),
  );
});

class AuthRepository {
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  final UserRepository _userRepository;

  AuthRepository({
    required FirebaseAuth auth,
    required GoogleSignIn googleSignIn,
    required UserRepository userRepository,
  })  : _auth = auth,
        _googleSignIn = googleSignIn,
        _userRepository = userRepository;

  Stream<User?> get authChangeState => _auth.authStateChanges();

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  FutureEither<UserModel> register({
    required String email,
    required String fullName,
    required String username,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      UserModel user;

      if (userCredential.additionalUserInfo!.isNewUser) {
        user = UserModel(
          id: userCredential.user!.uid,
          avatar: Constants.defaultAvatar,
          email: userCredential.user!.email!,
          name: fullName,
          username: username,
          role: UserRole.member,
          balance: 0,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        if (!_auth.currentUser!.emailVerified) {
          await _auth.currentUser!.sendEmailVerification();
          showSnackBar("Check your email for verification.");
        }

        await _userRepository.updateUser(user);
      } else {
        user = (await _userRepository
            .getUserData(userCredential.user!.uid)
            .first)!;
      }

      return right(user);
    } catch (e) {
      return left(getError(e));
    }
  }

  FutureEither<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user =
          await _userRepository.getUserData(userCredential.user!.uid).first;

      if (!_auth.currentUser!.emailVerified) {
        await _auth.currentUser!.sendEmailVerification();
        showSnackBar("Check your email for verification.");
      }
      return right(user!);
    } catch (e) {
      return left(getError(e));
    }
  }

  FutureEither<UserModel> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      UserModel user;

      if (userCredential.additionalUserInfo!.isNewUser) {
        final countRes = await _userRepository.getUserCount();
        final int count = countRes.fold((l) => throw l.message, (r) => r);

        user = UserModel(
          id: userCredential.user!.uid,
          avatar: userCredential.user!.photoURL ?? Constants.defaultAvatar,
          email: userCredential.user!.email!,
          name: userCredential.user!.displayName,
          username: 'user$count',
          role: UserRole.member,
          balance: 0,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await _userRepository.updateUser(user);
      } else {
        user = (await _userRepository
            .getUserData(userCredential.user!.uid)
            .first)!;
      }

      return right(user);
    } catch (e) {
      return left(getError(e));
    }
  }

  void logOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
