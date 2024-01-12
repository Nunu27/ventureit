import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ventureit/models/location.dart';
import 'package:ventureit/repositories/location_repository.dart';
import 'package:ventureit/utils.dart';

final locationProvider = StateProvider<LocationData?>((ref) => null);

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

  LocationController({required LocationRepository repository, required Ref ref})
      : _repository = repository,
        _ref = ref,
        super(false);

  void getLocation({bool force = false}) async {
    state = true;
    final locationRes = await _repository.getLocation(force);

    locationRes.fold(
      (l) {
        state = false;
        showSnackBar(l.message);
      },
      (position) async {
        final placemark = await getPlacemark(position);
        state = false;

        _ref.read(locationProvider.notifier).update(
              (state) => LocationData(
                placemark: placemark,
                position: position,
              ),
            );
      },
    );
  }
}
