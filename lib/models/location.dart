import 'package:geocoding/geocoding.dart';
import 'package:ventureit/models/base_position.dart';

class LocationModel {
  Placemark placemark;
  final BasePosition position;

  LocationModel({
    required this.placemark,
    required this.position,
  });

  LocationModel copyWith({
    Placemark? placemark,
    BasePosition? position,
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
      position: BasePosition.fromMap(map['position'] as Map<String, dynamic>),
    );
  }

  // factory LocationModel.fromPickedData(GeocodingResult data) {
  //   print(data.addressComponents);

  //   return LocationModel(
  //     position: BasePosition(
  //       latitude: data.geometry.location.lat,
  //       longitude: data.geometry.location.lng,
  //     ),
  //   );
  // }

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
