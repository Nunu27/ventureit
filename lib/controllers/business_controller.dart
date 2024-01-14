import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ventureit/controllers/location_controller.dart';
import 'package:ventureit/models/base_position.dart';
import 'package:ventureit/models/business/business.dart';
import 'package:ventureit/models/business/business_basic.dart';
import 'package:ventureit/models/filter_options.dart';
import 'package:ventureit/models/paginated_options.dart';
import 'package:ventureit/models/paginated_response.dart';
import 'package:ventureit/repositories/business_repository.dart';

final businessControllerProvider = Provider((ref) {
  return BusinessController(repository: ref.watch(businessRepositoryProvider));
});

final getBusinessByIdProvider = StreamProvider.family((ref, String id) {
  return ref.watch(businessControllerProvider).getBusinessById(id);
});

final paginatedFilterProvider = FutureProvider.family<
    PaginatedResponse<BusinessBasic>, PaginatedOptions<FilterOptions, int>>(
  (ref, PaginatedOptions<FilterOptions, int> options) async {
    final businessController = ref.watch(businessControllerProvider);
    final position = ref.watch(locationProvider)!.position;

    return await businessController.filterBusinesses(options, position);
  },
);

class BusinessController {
  final BusinessRepository _repository;

  BusinessController({required BusinessRepository repository})
      : _repository = repository;

  Stream<Business> getBusinessById(String id) {
    return _repository.getBusinessById(id);
  }

  Future<PaginatedResponse<BusinessBasic>> filterBusinesses(
    PaginatedOptions<FilterOptions, int> options,
    BasePosition position,
  ) async {
    return await _repository.filterBusinesses(
      options.data,
      options.offset,
      position,
    );
  }
}
