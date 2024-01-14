import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ventureit/controllers/location_controller.dart';
import 'package:ventureit/models/business/business.dart';
import 'package:ventureit/models/business/business_basic.dart';
import 'package:ventureit/models/filter_options.dart';
import 'package:ventureit/models/paginated_response.dart';
import 'package:ventureit/repositories/business_repository.dart';

final businessControllerProvider = Provider((ref) {
  return BusinessController(
    repository: ref.watch(businessRepositoryProvider),
    ref: ref,
  );
});

final getBusinessByIdProvider = StreamProvider.family((ref, String id) {
  return ref.watch(businessControllerProvider).getBusinessById(id);
});

final paginatedFilterProvider =
    FutureProvider.family<PaginatedResponse<BusinessBasic>, FilterOptions>(
  (ref, FilterOptions options) async {
    final businessController = ref.watch(businessControllerProvider);
    return await businessController.filterBusinesses(options);
  },
);

class BusinessController {
  final BusinessRepository _repository;
  final Ref _ref;

  BusinessController({required BusinessRepository repository, required Ref ref})
      : _repository = repository,
        _ref = ref;

  Stream<Business> getBusinessById(String id) {
    return _repository.getBusinessById(id);
  }

  Future<PaginatedResponse<BusinessBasic>> filterBusinesses(
      FilterOptions options) async {
    final position = _ref.read(locationProvider)!.position;

    return await _repository.filterBusinesses(options, position);
  }
}
