import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as loc;
import 'package:ventureit/models/base_position.dart';
import 'package:ventureit/models/location.dart';
import 'package:ventureit/type_defs.dart';
import 'package:ventureit/utils/location_utils.dart';
import 'package:ventureit/utils/utils.dart';

final locationRepositoryProvider = Provider((ref) {
  return LocationRepository();
});

class LocationRepository {
  FutureEither<LocationModel> getLocation(bool force) async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        final location = loc.Location();
        if (!force) throw 'Location services are disabled.';
        if (!(await location.requestService())) {
          throw 'Location services are disabled.';
        }
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Location permissions are denied';
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw 'Location permissions are permanently denied, we cannot request permissions.';
      }

      final position = BasePosition.fromPosition(
        await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        ),
      );
      final location = LocationModel(
        placemark: await getPlacemark(position),
        position: position,
      );

      return right(location);
    } catch (e) {
      return left(getError(e));
    }
  }
}
