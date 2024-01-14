import 'package:geocoding/geocoding.dart';
import 'package:ventureit/models/base_position.dart';

String convertToPrecisionString(double number, {int precision = 1}) {
  String result = number.toStringAsFixed(precision);

  if (precision == 0) {
    result = result.replaceAll(RegExp(r'\.0*$'), '');
  }

  return result;
}

String formatDistance(double distance) {
  if (distance >= 500) return '${convertToPrecisionString(distance / 1000)} km';
  return '${distance.round()} m';
}

Future<Placemark> getPlacemark(BasePosition position) async {
  List<Placemark> placemarks = await placemarkFromCoordinates(
    position.latitude,
    position.longitude,
  );

  return placemarks.first;
}

String addressNullCheck(String? data, {bool isLast = false}) {
  return (data == null || data.isEmpty) ? '' : (data + (isLast ? '' : ', '));
}

String getFullAddress(Placemark placemark) {
  return '${addressNullCheck(placemark.name)}${addressNullCheck(placemark.street)}${addressNullCheck(placemark.subLocality)}${addressNullCheck(placemark.locality)}${addressNullCheck(placemark.subAdministrativeArea)}${addressNullCheck(placemark.administrativeArea, isLast: true)} ${addressNullCheck(placemark.postalCode)}${addressNullCheck(placemark.country, isLast: true)}';
}
