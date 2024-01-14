import 'package:geolocator/geolocator.dart';
import 'package:ventureit/models/base_position.dart';
import 'package:ventureit/models/open_hours.dart';
import 'package:ventureit/utils/location_utils.dart';

class BusinessModel {
  final BasePosition location;
  final List<OpenHours> openHours;
  String? distance;

  BusinessModel({
    required this.location,
    required this.openHours,
    this.distance,
  });

  String getDistance(BasePosition from) {
    distance ??= formatDistance(
      Geolocator.distanceBetween(
        from.latitude,
        from.longitude,
        location.latitude,
        location.longitude,
      ),
    );

    return distance!;
  }

  OpenHours? getOpenHours() {
    final now = DateTime.now();

    for (var openHour in openHours) {
      if (openHour.days.lowerBound <= now.weekday &&
          openHour.days.upperBound >= now.weekday) {
        return openHour;
      }
    }

    return null;
  }
}
