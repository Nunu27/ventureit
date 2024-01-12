import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:ventureit/controllers/user_controller.dart';
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

  Future<void> getCurrentUser() async {
    final user = _repository.getCurrentUser();

    if (user == null) return;

    final res =
        await _ref.read(userControllerProvider).getUserData(user.uid).first;
    _ref.read(userProvider.notifier).update((state) => res);
  }

  void register({
    required BuildContext context,
    required String email,
    required String fullName,
    required String username,
    required String password,
  }) async {
    state = true;
    final user = await _repository.register(
      email: email,
      fullName: fullName,
      username: username,
      password: password,
    );
    state = false;

    user.fold(
      (l) => showSnackBar(l.message),
      (r) {
        _ref.read(userProvider.notifier).update((state) => r);
        Routemaster.of(context).replace(
          r.role == UserRole.admin ? '/admin' : '/member',
        );
      },
    );
  }

  void login({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    state = true;
    final user = await _repository.login(email: email, password: password);
    state = false;

    user.fold(
      (l) => showSnackBar(l.message),
      (r) {
        _ref.read(userProvider.notifier).update((state) => r);
        Routemaster.of(context).replace(
          r.role == UserRole.admin ? '/admin' : '/member',
        );
      },
    );
  }

  void loginWithGoogle(BuildContext context) async {
    state = true;
    final user = await _repository.loginWithGoogle();
    state = false;

    user.fold(
      (l) => showSnackBar(l.message),
      (r) {
        _ref.read(userProvider.notifier).update((state) => r);
        Routemaster.of(context).replace(
          r.role == UserRole.admin ? '/admin' : '/member',
        );
      },
    );
  }

  void logOut() {
    _repository.logOut();
    _ref.read(userProvider.notifier).update((state) => null);
  }
}
