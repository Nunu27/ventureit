import 'package:firebase_auth/firebase_auth.dart';
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

  void signUp({
    required String email,
    required String username,
    required String password,
  }) async {
    state = true;
    final user = await _repository.signUp(
      email: email,
      username: username,
      password: password,
    );
    state = false;

    user.fold(
      (l) => showSnackBar(l.message),
      (r) => _ref.read(userProvider.notifier).update((state) => r),
    );
  }

  void signIn({
    required String email,
    required String password,
  }) async {
    state = true;
    final user = await _repository.signIn(email: email, password: password);
    state = false;

    user.fold(
      (l) => showSnackBar(l.message),
      (r) => _ref.read(userProvider.notifier).update((state) => r),
    );
  }

  void signInWithGoogle() async {
    state = true;
    final user = await _repository.signInWithGoogle();
    state = false;

    user.fold(
      (l) => showSnackBar(l.message),
      (r) => _ref.read(userProvider.notifier).update((state) => r),
    );
  }

  void signOut() {
    _repository.signOut();
  }

  void deleteAccount() async {
    state = true;
    final res = await _repository.deleteAccount();
    state = false;

    res.fold(
      (l) => showSnackBar(l.message),
      (r) => _ref.read(userProvider.notifier).update((state) => null),
    );
  }
}
