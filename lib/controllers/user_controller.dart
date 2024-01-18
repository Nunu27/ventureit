import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:ventureit/controllers/auth_controller.dart';
import 'package:ventureit/models/user.dart';
import 'package:ventureit/repositories/storage_repository.dart';
import 'package:ventureit/repositories/user_repository.dart';
import 'package:ventureit/utils/utils.dart';

final userControllerProvider =
    StateNotifierProvider<UserController, bool>((ref) {
  return UserController(
    repository: ref.watch(userRepositoryProvider),
    storageRepository: ref.watch(storageRepositoryProvider),
    ref: ref,
  );
});

final getUserDataProvider = StreamProvider.family((ref, String id) {
  final authController = ref.watch(userControllerProvider.notifier);

  return authController.getUserData(id);
});

class UserController extends StateNotifier<bool> {
  final UserRepository _repository;
  final StorageRepository _storageRepository;
  final Ref _ref;

  UserController({
    required UserRepository repository,
    required StorageRepository storageRepository,
    required Ref ref,
  })  : _repository = repository,
        _storageRepository = storageRepository,
        _ref = ref,
        super(false);

  Stream<UserModel?> getUserData(id) {
    return _repository.getUserData(id);
  }

  void updateBalance(String id, int balance) async {
    state = true;
    final res = await _repository.updateBalance(id, balance);
    state = false;

    res.fold(
      (l) => showSnackBar(l.message),
      (r) => _ref.read(userProvider.notifier).update(
            (state) => state!.copyWith(balance: state.balance + balance),
          ),
    );
  }

  void updateUser(BuildContext context, UserModel user, File? avatar) async {
    state = true;

    if (avatar != null) {
      final avatarRes = await _storageRepository.storeFile(
        path: '/images/avatar',
        id: user.id,
        file: avatar,
      );

      avatarRes.fold(
        (l) => showSnackBar(l.message),
        (r) => user = user.copyWith(avatar: r),
      );
    }

    final res = await _repository.updateUser(user);
    state = false;

    res.fold(
      (l) {
        showSnackBar(l.message);
      },
      (r) {
        if (_ref.read(userProvider)?.id == user.id) {
          _ref.read(userProvider.notifier).update((state) => user);
        }
        showSnackBar('Profile updated');
        Routemaster.of(context).pop();
      },
    );
  }
}
