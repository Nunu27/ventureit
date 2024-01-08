import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ventureit/repositories/business_repository.dart';

final businessControllerProvider = Provider((ref) {
  return BusinessController(
    repository: ref.watch(businessRepositoryProvider),
  );
});

class BusinessController {
  final BusinessRepository _repository;

  BusinessController({required BusinessRepository repository})
      : _repository = repository;
}
