import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ventureit/models/filter_options.dart';
import 'package:ventureit/widgets/modal_sheet/filter_modal.dart';
import 'package:ventureit/widgets/modal_sheet/location_modal_sheet.dart';

final modalControllerProvider = Provider((ref) {
  return ModalController();
});

class ModalController {
  bool locationPickEnabled = false;
  bool filterEnabled = false;

  Future<void> showLocationPickerSheet(BuildContext context) async {
    if (locationPickEnabled) return;
    locationPickEnabled = true;

    await showModalBottomSheet(
      context: context,
      isDismissible: false,
      isScrollControlled: true,
      enableDrag: false,
      builder: (context) => const LocationModalSheet(),
    );
    locationPickEnabled = false;
  }

  Future<FilterOptions?> showFilterOptions(
    BuildContext context,
    FilterOptions options,
  ) async {
    if (filterEnabled) return null;
    filterEnabled = true;

    final newOptions = await showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => FilterModal(options: options.copyWith()),
    );
    filterEnabled = false;

    return newOptions;
  }
}
