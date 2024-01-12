import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:ventureit/controllers/location_controller.dart';
import 'package:ventureit/models/business/business.dart';
import 'package:ventureit/models/filter_options.dart';
import 'package:ventureit/providers/geo_provider.dart';
import 'package:ventureit/repositories/business_repository.dart';

final businessControllerProvider = Provider((ref) {
  return BusinessController(
    repository: ref.watch(businessRepositoryProvider),
    ref: ref,
  );
});

final filterBusinessProvider =
    StreamProvider.family((ref, FilterOptions options) {
  return ref.watch(businessControllerProvider).filterBusinesses(options);
});

class BusinessController {
  final BusinessRepository _repository;
  final Ref _ref;

  BusinessController({required BusinessRepository repository, required Ref ref})
      : _repository = repository,
        _ref = ref;

  Stream<List<Business>> filterBusinesses(FilterOptions options) {
    final position = _ref.read(locationProvider)!.position;
    final geo = _ref.read(geoProvider);

    GeoFirePoint center = geo.point(
      latitude: position.latitude,
      longitude: position.longitude,
    );

    return _repository.filterBusinesses(options, geo, center);
  }
}
