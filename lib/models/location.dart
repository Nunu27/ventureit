import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationData {
  final Placemark placemark;
  final Position position;

  LocationData({required this.placemark, required this.position});
}
