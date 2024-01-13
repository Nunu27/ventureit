import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationModel {
  final Placemark placemark;
  final Position position;

  LocationModel({
    required this.placemark,
    required this.position,
  });

  LocationModel copyWith({
    Placemark? placemark,
    Position? position,
  }) {
    return LocationModel(
      placemark: placemark ?? this.placemark,
      position: position ?? this.position,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'placemark': placemark.toJson(),
      'position': {
        'latitude': position.latitude,
        'longitude': position.longitude,
      },
    };
  }

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      placemark: Placemark.fromMap(map['placemark'] as Map<String, dynamic>),
      position: Position.fromMap(map['position'] as Map<String, dynamic>),
    );
  }

  @override
  String toString() =>
      'LocationData(placemark: $placemark, position: $position)';

  @override
  bool operator ==(covariant LocationModel other) {
    if (identical(this, other)) return true;

    return other.placemark == placemark && other.position == position;
  }

  @override
  int get hashCode => placemark.hashCode ^ position.hashCode;
}
