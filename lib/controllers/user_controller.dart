import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ventureit/models/user.dart';
import 'package:ventureit/repositories/user_repository.dart';

final userControllerProvider = Provider((ref) {
  return UserController(repository: ref.watch(userRepositoryProvider));
});

final getUserDataProvider = StreamProvider.family((ref, String id) {
  final authController = ref.watch(userControllerProvider);

  return authController.getUserData(id);
});

class UserController {
  final UserRepository _repository;

  UserController({required UserRepository repository})
      : _repository = repository;

  Stream<UserModel?> getUserData(id) {
    return _repository.getUserData(id);
  }
}
