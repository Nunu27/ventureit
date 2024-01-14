import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:routemaster/routemaster.dart';
import 'package:ventureit/models/base_position.dart';
import 'package:ventureit/models/location.dart';
import 'package:ventureit/utils/location_utils.dart';
import 'package:ventureit/widgets/loader.dart';
import 'package:ventureit/widgets/primary_button.dart';

class LocationPicker extends StatefulWidget {
  late final CameraPosition _camPos;

  LocationPicker({super.key, BasePosition? initialPosition}) {
    if (initialPosition == null) {
      _camPos = const CameraPosition(
        target: LatLng(-7.607155477527343, 109.69302616967902),
        zoom: 6,
      );
    } else {
      _camPos = CameraPosition(
        target: LatLng(initialPosition.latitude, initialPosition.longitude),
        zoom: 14,
      );
    }
  }

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  bool isLoading = false;
  LatLng center = const LatLng(-7.607155477527343, 109.69302616967902);
  Placemark placemark = Placemark();

  onCameraMove(CameraPosition position) {
    center = position.target;
  }

  onCameraStartMove() {
    setState(() {
      isLoading = true;
    });
  }

  getLocation() async {
    final position = BasePosition(
      latitude: center.latitude,
      longitude: center.longitude,
    );

    try {
      final newPlacemark = await getPlacemark(position);

      placemark = newPlacemark;
      isLoading = false;
    } catch (e) {
      placemark = Placemark();
      isLoading = false;
    }

    if (mounted) setState(() {});
  }

  void goBack({bool isCancel = false}) {
    Routemaster.of(context).pop(isCancel
        ? null
        : LocationModel(
            placemark: placemark,
            position: BasePosition.fromLatLng(center),
          ));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                GoogleMap(
                  rotateGesturesEnabled: false,
                  buildingsEnabled: false,
                  mapToolbarEnabled: false,
                  tiltGesturesEnabled: false,
                  zoomControlsEnabled: false,
                  initialCameraPosition: widget._camPos,
                  onCameraIdle: getLocation,
                  onCameraMove: onCameraMove,
                  onCameraMoveStarted: onCameraStartMove,
                ),
                Align(
                  alignment: Alignment.center,
                  child: FittedBox(
                    child: Transform.translate(
                      offset: const Offset(0, -25),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Colors.red,
                            size: 50,
                          ),
                          Container(
                            height: 5,
                            width: 5,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2.5),
                              color: Colors.amber,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 18,
                  bottom: 36,
                  child: IconButton.filled(
                    color: theme.colorScheme.onBackground,
                    style: IconButton.styleFrom(
                      backgroundColor: theme.colorScheme.background,
                    ),
                    onPressed: () => goBack(isCancel: true),
                    icon: const Icon(Icons.arrow_back),
                  ),
                ),
              ],
            ),
          ),
          Transform.translate(
            offset: const Offset(0, -18),
            child: Container(
              height: 200,
              padding: const EdgeInsets.all(18).copyWith(bottom: 0),
              width: double.infinity,
              decoration: BoxDecoration(
                color: theme.colorScheme.background,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Select location",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Expanded(
                    child: Row(children: [
                      const Icon(
                        Icons.location_on,
                        size: 50,
                        color: Colors.red,
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        child: isLoading
                            ? const Loader()
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    placemark.street ?? 'Unknown',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  Flexible(
                                    child: Text(
                                      getFullAddress(placemark),
                                      style: const TextStyle(fontSize: 13),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ]),
                  ),
                  PrimaryButton(
                    onPress: isLoading
                        ? null
                        : () {
                            goBack();
                          },
                    child: const Text('Confirm Location'),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
