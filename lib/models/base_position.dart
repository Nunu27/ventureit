import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BasePosition {
  final double latitude;
  final double longitude;

  BasePosition({
    required this.latitude,
    required this.longitude,
  });

  BasePosition copyWith({
    double? latitude,
    double? longitude,
  }) {
    return BasePosition(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory BasePosition.fromMap(Map<String, dynamic> map) {
    return BasePosition(
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
    );
  }

  factory BasePosition.fromLatLng(LatLng position) {
    return BasePosition(
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }

  factory BasePosition.fromPosition(Position position) {
    return BasePosition(
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }

  @override
  String toString() =>
      'BasePosition(latitude: $latitude, longitude: $longitude)';

  @override
  bool operator ==(covariant BasePosition other) {
    if (identical(this, other)) return true;

    return other.latitude == latitude && other.longitude == longitude;
  }

  @override
  int get hashCode => latitude.hashCode ^ longitude.hashCode;
}
