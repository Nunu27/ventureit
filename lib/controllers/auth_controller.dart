import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ventureit/models/user.dart';
import 'package:ventureit/repositories/auth_repository.dart';
import 'package:ventureit/utils.dart';

final userProvider = StateProvider<UserModel?>((ref) => null);

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(
    repository: ref.watch(authRepositoryProvider),
    ref: ref,
  );
});

final authStateChangeProvider = StreamProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);

  return authController.authStateChange;
});

class AuthController extends StateNotifier<bool> {
  final AuthRepository _repository;
  final Ref _ref;

  AuthController({required AuthRepository repository, required Ref ref})
      : _repository = repository,
        _ref = ref,
        super(false);

  Stream<User?> get authStateChange => _repository.authChangeState;

  void signInWithGoogle(BuildContext context) async {
    state = true;
    final user = await _repository.signInWithGoogle();
    state = false;

    user.fold((l) => showSnackBar(context, l.message),
        (r) => _ref.read(userProvider.notifier).update((state) => r));
  }

  void logOut() {
    _repository.logOut();
  }
}
