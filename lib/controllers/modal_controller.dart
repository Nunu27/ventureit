import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ventureit/controllers/location_controller.dart';
import 'package:ventureit/models/business/business.dart';
import 'package:ventureit/models/business/external_link.dart';
import 'package:ventureit/models/filter_options.dart';
import 'package:ventureit/models/location.dart';
import 'package:ventureit/models/open_hours.dart';
import 'package:ventureit/widgets/modal_sheet/category_select.dart';
import 'package:ventureit/widgets/modal_sheet/external_link_modal.dart';
import 'package:ventureit/widgets/modal_sheet/filter_modal.dart';
import 'package:ventureit/widgets/modal_sheet/location_modal_sheet.dart';
import 'package:ventureit/screens/location_picker.dart';
import 'package:ventureit/widgets/modal_sheet/open_hours_modal.dart';
import 'package:ventureit/widgets/modal_sheet/review_modal.dart';

final modalControllerProvider = Provider((ref) {
  return ModalController(ref: ref);
});

class ModalController {
  final Ref _ref;
  bool _locationEnabled = false;
  bool modalActive = false;

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
    modalActive = true;
    final LocationModel? location = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      enableDrag: false,
      builder: (context) => LocationPicker(
        initialPosition: _ref.read(locationProvider)?.position,
      ),
    );
    modalActive = false;

    return location;
  }

  Future<FilterOptions?> showFilterOptions(
    BuildContext context,
    FilterOptions options,
  ) async {
    modalActive = true;
    final newOptions = await showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      showDragHandle: true,
      enableDrag: false,
      builder: (context) => FilterModal(options: options.copyWith()),
    );
    modalActive = false;

    return newOptions;
  }

  Future<BusinessCategory?> showCategorySelect(
    BuildContext context,
    BusinessCategory? current,
  ) async {
    modalActive = true;
    final category = await showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      showDragHandle: true,
      enableDrag: false,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        shouldCloseOnMinExtent: true,
        expand: false,
        initialChildSize: 0.4,
        minChildSize: 0.4,
        builder: (context, scrollController) => CategorySelectModal(
          selected: current,
          scrollController: scrollController,
        ),
      ),
    );
    modalActive = false;

    return category;
  }

  Future<List<OpenHours>?> showOpenHoursModal(
    BuildContext context,
    List<OpenHours> current,
  ) async {
    modalActive = true;
    final category = await showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      showDragHandle: true,
      enableDrag: false,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        shouldCloseOnMinExtent: true,
        expand: false,
        snap: true,
        snapSizes: const [0.6, 1],
        initialChildSize: 0.6,
        builder: (context, scrollController) => OpenHoursModal(
          state: current,
          scrollController: scrollController,
        ),
      ),
    );
    modalActive = false;

    return category;
  }

  Future<List<ExternalLink>?> showExternalLinksModal(
    BuildContext context,
    List<ExternalLink> current,
  ) async {
    modalActive = true;
    final category = await showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      showDragHandle: true,
      enableDrag: false,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        shouldCloseOnMinExtent: true,
        expand: false,
        initialChildSize: 1,
        minChildSize: 1,
        builder: (context, scrollController) => ExternalLinksModal(
          state: current,
          scrollController: scrollController,
        ),
      ),
    );
    modalActive = false;

    return category;
  }

  Future<void> showReviewModal(
    BuildContext context,
    String businessId,
  ) async {
    await showModalBottomSheet(
      context: context,
      builder: (context) => ReviewModal(),
    );
  }
}
