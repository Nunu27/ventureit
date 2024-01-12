import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';

final geoProvider = Provider((ref) {
  return GeoFlutterFire();
});
