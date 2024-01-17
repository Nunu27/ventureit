import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ventureit/models/location.dart';
import 'package:ventureit/repositories/location_repository.dart';
import 'package:ventureit/utils/utils.dart';

final locationProvider = StateProvider<LocationModel?>((ref) => null);

final locationControllerProvider =
    StateNotifierProvider<LocationController, bool>((ref) {
  return LocationController(
    repository: ref.watch(locationRepositoryProvider),
    ref: ref,
  );
});

class LocationController extends StateNotifier<bool> {
  final LocationRepository _repository;
  final Ref _ref;
  LocationModel? userLocation;

  LocationController({required LocationRepository repository, required Ref ref})
      : _repository = repository,
        _ref = ref,
        super(false);

  Future<bool> getLocation({bool force = false}) async {
    state = true;
    final locationRes = await _repository.getLocation(force);
    state = false;

    return locationRes.fold(
      (l) {
        showSnackBar(l.message);
        return false;
      },
      (location) {
        userLocation = location;
        _ref.read(locationProvider.notifier).update((state) => location);
        return true;
      },
    );
  }
}
