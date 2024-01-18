import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';
import 'package:ventureit/controllers/auth_controller.dart';
import 'package:ventureit/models/business/business_product_item.dart';
import 'package:ventureit/models/submission/add_submission.dart';
import 'package:ventureit/models/submission/edit_submission.dart';
import 'package:ventureit/models/submission/entry_submission.dart';
import 'package:ventureit/models/submission/remove_submission.dart';
import 'package:ventureit/models/submission/submission.dart';
import 'package:ventureit/providers/add_submission_provider.dart';
import 'package:ventureit/providers/edit_business_provider.dart';
import 'package:ventureit/repositories/storage_repository.dart';
import 'package:ventureit/repositories/submission_repository.dart';
import 'package:ventureit/utils/utils.dart';

final submissionControllerProvider =
    StateNotifierProvider<SubmissionController, bool>((ref) {
  return SubmissionController(
    repository: ref.watch(submissionRepositoryProvider),
    storageRepo: ref.watch(storageRepositoryProvider),
    ref: ref,
  );
});

final getPendingSubmissionsProvider = StreamProvider((ref) {
  return ref
      .watch(submissionControllerProvider.notifier)
      .getPendingSubmissions();
});

final getSubmissionByUserIdProvider = StreamProvider.family((ref, String id) {
  return ref
      .watch(submissionControllerProvider.notifier)
      .getSubmissionByUserId(id);
});
final getSubmissionByIdProvider = StreamProvider.family((ref, String id) {
  return ref.watch(submissionControllerProvider.notifier).getSubmissionById(id);
});

class SubmissionController extends StateNotifier<bool> {
  final Ref _ref;
  final SubmissionRepository _repository;
  final StorageRepository _storageRepo;

  SubmissionController({
    required SubmissionRepository repository,
    required StorageRepository storageRepo,
    required Ref ref,
  })  : _repository = repository,
        _storageRepo = storageRepo,
        _ref = ref,
        super(false);

  void approve(BuildContext context, Submission submission) async {
    state = true;
    final res = await _repository.approveSubmission(submission);
    state = false;

    res.fold(
      (l) => showSnackBar(l.message),
      (r) => Routemaster.of(context).pop(),
    );
  }

  void reject(BuildContext context, Submission submission) async {
    state = true;
    final res = await _repository.rejectSubmission(submission);
    state = false;

    res.fold(
      (l) => showSnackBar(l.message),
      (r) => Routemaster.of(context).pop(),
    );
  }

  Stream<List<Submission>> getPendingSubmissions() {
    return _repository.getPendingSubmissions();
  }

  Stream<List<Submission>> getSubmissionByUserId(String id) {
    return _repository.getSubmissionByUserId(id);
  }

  Stream<Submission> getSubmissionById(String id) {
    return _repository.getSubmissionById(id);
  }

  void addEntrySubmission({
    required AddSubmissionState data,
    required BuildContext context,
  }) async {
    state = true;
    var uuid = const Uuid();

    String? coverUrl;

    final coverRes = await _storageRepo.storeFile(
      path: '/images/cover',
      id: uuid.v4(),
      file: data.cover!,
    );

    coverRes.fold(
      (l) {
        showSnackBar(l.message);
      },
      (r) => coverUrl = r,
    );

    if (coverUrl == null) {
      state = false;
      return;
    }
    List<BusinessProductItem> products = [];

    for (var entry in data.products) {
      String? picUrl;
      final picRes = await _storageRepo.storeFile(
        path: '/images/products',
        id: uuid.v4(),
        file: entry.picture!,
      );

      picRes.fold(
        (l) => showSnackBar(l.message),
        (r) => picUrl = r,
      );

      if (picUrl == null) {
        state = false;
        return;
      }

      products.add(
        BusinessProductItem(
          name: entry.name,
          price: entry.price,
          picture: picUrl!,
          updatedAt: DateTime.now(),
        ),
      );
    }

    final submission = Submission(
      id: uuid.v4(),
      userId: _ref.read(userProvider)!.id,
      data: [
        EntrySubmission(
          name: data.name,
          description: data.description,
          location: data.location!,
          cover: coverUrl!,
          category: data.category!,
          openHours: data.openHours,
          products: products,
          externalLinks: data.externalLinks,
          contents: data.contents,
        )
      ],
      status: SubmissionStatus.pending,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final res = await _repository.submitSubmission(submission);
    state = false;

    res.fold((l) => showSnackBar(l.message), (r) {
      _ref.read(addSubmissionProvider.notifier).update((state) => null);
      Routemaster.of(context).replace('/member/profile');
    });
  }

  void addEditSubmission({
    required EditBusinessState data,
    required BuildContext context,
  }) async {
    state = true;
    var uuid = const Uuid();
    List<SubmissionData> submissionData = [];

    if (data.reference.name != data.name) {
      submissionData.add(
        EditSubmission(key: 'name', value: data.name),
      );
    }
    if (data.reference.description != data.description) {
      submissionData.add(
        EditSubmission(key: 'description', value: data.description),
      );
    }
    if (data.reference.category != data.category) {
      submissionData.add(
        EditSubmission(key: 'category', value: data.category.name),
      );
    }
    if (data.reference.location != data.location.position) {
      submissionData.addAll([
        EditSubmission(key: 'location', value: data.location.position.toMap()),
        EditSubmission(
            key: 'placemark', value: data.location.placemark.toJson()),
      ]);
    }

    if (data.cover != null) {
      String? coverUrl;

      final coverRes = await _storageRepo.storeFile(
        path: '/images/cover',
        id: uuid.v4(),
        file: data.cover!,
      );

      coverRes.fold(
        (l) {
          showSnackBar(l.message);
        },
        (r) => coverUrl = r,
      );

      if (coverUrl == null) {
        state = false;
        return;
      }

      submissionData.add(EditSubmission(key: 'description', value: coverUrl));
    }

    List<BusinessProductItem> products = [];

    if (data.removedProducts.isNotEmpty) {
      submissionData.add(RemoveSubmission(
          key: 'products', value: data.removedProducts.map((e) => e.toMap())));
    }

    for (var entry in data.newProducts) {
      String? picUrl;
      final picRes = await _storageRepo.storeFile(
        path: '/images/products',
        id: uuid.v4(),
        file: entry.picture!,
      );

      picRes.fold(
        (l) => showSnackBar(l.message),
        (r) => picUrl = r,
      );

      if (picUrl == null) {
        state = false;
        return;
      }

      products.add(
        BusinessProductItem(
          name: entry.name,
          price: entry.price,
          picture: picUrl!,
          updatedAt: DateTime.now(),
        ),
      );
    }

    if (products.isNotEmpty) {
      submissionData.add(AddSubmission(
          key: 'products', value: products.map((e) => e.toMap())));
    }

    final removedOpenHours =
        data.reference.openHours.filter((t) => !data.openHours.contains(t));
    final newOpenHours =
        data.openHours.filter((t) => !data.reference.openHours.contains(t));
    final removedContents = data.reference.contents.tiktok
        .filter((t) => !data.contents.contains(t));
    final newContents = data.contents
        .filter((t) => !data.reference.contents.tiktok.contains(t));
    final removedExternalLinks = data.reference.externalLinks
        .filter((t) => !data.externalLinks.contains(t));
    final newExternalLinks = data.externalLinks
        .filter((t) => !data.reference.externalLinks.contains(t));

    if (removedOpenHours.isNotEmpty) {
      submissionData.add(RemoveSubmission(
          key: 'openHours', value: removedOpenHours.map((e) => e.toMap())));
    }
    if (newOpenHours.isNotEmpty) {
      submissionData.add(AddSubmission(
          key: 'openHours', value: newOpenHours.map((e) => e.toMap())));
    }
    if (removedContents.isNotEmpty) {
      submissionData.add(RemoveSubmission(
          key: 'contents', value: removedContents.map((e) => e.toMap())));
    }
    if (newContents.isNotEmpty) {
      submissionData.add(AddSubmission(
          key: 'contents', value: newContents.map((e) => e.toMap())));
    }
    if (removedExternalLinks.isNotEmpty) {
      submissionData.add(RemoveSubmission(
          key: 'externalLinks',
          value: removedExternalLinks.map((e) => e.toMap())));
    }
    if (newExternalLinks.isNotEmpty) {
      submissionData.add(AddSubmission(
          key: 'externalLinks', value: newExternalLinks.map((e) => e.toMap())));
    }

    final submission = Submission(
      id: uuid.v4(),
      userId: _ref.read(userProvider)!.id,
      data: submissionData,
      status: SubmissionStatus.pending,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final res = await _repository.submitSubmission(submission);
    state = false;

    res.fold((l) => showSnackBar(l.message), (r) {
      _ref.read(addSubmissionProvider.notifier).update((state) => null);
      Routemaster.of(context).replace('/member/explore');
    });
  }
}
