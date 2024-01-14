import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ventureit/models/submission/submission.dart';
import 'package:ventureit/repositories/submission_repository.dart';

final submissionControllerProvider = Provider((ref) {
  return SubmissionController(
    repository: ref.watch(submissionRepositoryProvider),
  );
});

class SubmissionController {
  final SubmissionRepository _repository;

  SubmissionController({
    required SubmissionRepository repository,
  }) : _repository = repository;

  Stream<List<Submission>> getSubmissionByUserId(String id) {
    return _repository.getSubmissionByUserId(id);
  }

  Stream<Submission> getSubmissionById(String id) {
    return _repository.getSubmissionById(id);
  }
}
