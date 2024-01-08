import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ventureit/repositories/submission_repository.dart';

final submissionControllerProvider = Provider((ref) {
  return SubmissionController(
    repository: ref.watch(submissionRepositoryProvider),
  );
});

class SubmissionController {
  final SubmissionRepository _repository;

  SubmissionController({required SubmissionRepository repository})
      : _repository = repository;
}
