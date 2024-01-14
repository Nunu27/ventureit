import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ventureit/controllers/location_controller.dart';
import 'package:ventureit/models/filter_options.dart';
import 'package:ventureit/models/location.dart';
import 'package:ventureit/widgets/modal_sheet/filter_modal.dart';
import 'package:ventureit/widgets/modal_sheet/location_modal_sheet.dart';
import 'package:ventureit/screens/location_picker.dart';

final modalControllerProvider = Provider((ref) {
  return ModalController(ref: ref);
});

class ModalController {
  final Ref _ref;
  bool _locationEnabled = false;
  bool _locationPickEnabled = false;
  bool _filterEnabled = false;

  ModalController({required Ref ref}) : _ref = ref;

  Future<void> showLocationSheet(BuildContext context) async {
    if (_locationEnabled) return;
    _locationEnabled = true;

    await showModalBottomSheet(
      context: context,
      isDismissible: false,
      isScrollControlled: true,
      enableDrag: false,
      builder: (context) => const LocationModalSheet(),
    );
    _locationEnabled = false;
  }

  Future<LocationModel?> showLocationPickerSheet(BuildContext context) async {
    if (_locationPickEnabled) return null;
    _locationPickEnabled = true;

    final LocationModel? location = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      enableDrag: false,
      builder: (context) => LocationPicker(
        initialPosition: _ref.read(locationProvider)?.position,
      ),
    );
    _locationPickEnabled = false;
    return location;
  }

  Future<FilterOptions?> showFilterOptions(
    BuildContext context,
    FilterOptions options,
  ) async {
    if (_filterEnabled) return null;
    _filterEnabled = true;

    final newOptions = await showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      showDragHandle: true,
      enableDrag: false,
      builder: (context) => FilterModal(options: options.copyWith()),
    );
    _filterEnabled = false;

    return newOptions;
  }
}
