import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:ventureit/controllers/modal_controller.dart';
import 'package:ventureit/controllers/submission_controller.dart';
import 'package:ventureit/providers/add_submission_provider.dart';
import 'package:ventureit/utils/location_utils.dart';
import 'package:ventureit/utils/picker.dart';
import 'package:ventureit/utils/utils.dart';
import 'package:ventureit/widgets/loader_overlay.dart';
import 'package:ventureit/widgets/submission_card/external_link_card.dart';
import 'package:ventureit/widgets/submission_card/open_hours_card.dart';
import 'package:ventureit/widgets/input/pressable_input.dart';
import 'package:ventureit/widgets/input/text_input.dart';
import 'package:ventureit/widgets/primary_button.dart';
import 'package:ventureit/widgets/secondary_button.dart';

class AddSubmissionGeneral extends ConsumerStatefulWidget {
  const AddSubmissionGeneral({super.key});

  @override
  ConsumerState<AddSubmissionGeneral> createState() =>
      _AddSubmissionGeneralState();
}

class _AddSubmissionGeneralState extends ConsumerState<AddSubmissionGeneral> {
  AddSubmissionState? state;
  TextEditingController? nameController;
  TextEditingController? descriptionController;

  List<MapEntry<int, String>> closedDays = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      AddSubmissionState? stateData = ref.read(addSubmissionProvider);
      if (stateData == null) {
        stateData = AddSubmissionState();
        ref.read(addSubmissionProvider.notifier).update((state) => stateData);
      }

      state = stateData;
      closedDays = getClosedDays(state!.openHours);

      nameController = TextEditingController(text: state!.name);
      descriptionController = TextEditingController(text: state!.description);
      setState(() {});
    });
  }

  @override
  void dispose() {
    nameController?.dispose();
    descriptionController?.dispose();
    super.dispose();
  }

  void selectCover() async {
    final res = await pickImage();

    if (res != null) {
      state!.cover = File(res.files.first.path!);
      setState(() {});
    }
  }

  void selectLocation() async {
    final newLocation = await ref
        .read(modalControllerProvider)
        .showLocationPickerSheet(context);

    if (newLocation != null) {
      state!.location = newLocation;
      setState(() {});
    }
  }

  void selectCategory() async {
    final category = await ref
        .read(modalControllerProvider)
        .showCategorySelect(context, state?.category);

    state!.category = category;
    setState(() {});
  }

  void selectOpenHours() async {
    final openHours = await ref
        .read(modalControllerProvider)
        .showOpenHoursModal(context, state!.openHours);

    if (openHours != null) {
      state!.openHours = openHours;
      closedDays = getClosedDays(state!.openHours);
      setState(() {});
    }
  }

  void selectExternalLinks() async {
    final externalLinks = await ref
        .read(modalControllerProvider)
        .showExternalLinksModal(context, state!.externalLinks);

    if (externalLinks != null) {
      state!.externalLinks = externalLinks;
      setState(() {});
    }
  }

  void navigateToProducts() {
    if (state?.cover == null ||
        state?.location == null ||
        state?.category == null ||
        nameController!.text.isEmpty) {
      showSnackBar("Please fill all the required field");
      return;
    }

    state?.name = nameController!.text;
    state?.description = descriptionController!.text;

    FocusManager.instance.primaryFocus?.unfocus();
    Routemaster.of(context).push('products');
  }

  void submit() async {
    if (state?.cover == null ||
        state?.location == null ||
        state?.category == null ||
        nameController!.text.isEmpty) {
      showSnackBar("Please fill all the required field");
      return;
    }

    state?.name = nameController!.text;
    state?.description = descriptionController!.text;

    FocusManager.instance.primaryFocus?.unfocus();
    ref
        .read(submissionControllerProvider.notifier)
        .addEntrySubmission(data: state!, context: context);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(submissionControllerProvider);
    final theme = Theme.of(context);

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (!didPop) {
          FocusManager.instance.primaryFocus?.unfocus();
          if (await showDiscardData(context, ref)) {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.of(context).pop();
            });
          }
        }
      },
      child: LoaderOverlay(
        isLoading: isLoading,
        child: Scaffold(
          appBar: AppBar(
            forceMaterialTransparency: true,
            title: const Text('Add business data'),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(18.0).copyWith(top: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(18),
                    child: const Row(
                      children: [
                        Icon(Icons.info_outline),
                        SizedBox(width: 10),
                        Flexible(
                          child: Text(
                              'Please fill in any details you know about this business.'),
                        ),
                      ],
                    ),
                  ),
                  CustomPressableInput(
                    onPress: selectCover,
                    label: 'Cover image',
                    height: 200,
                    child: state?.cover == null
                        ? const Center(child: Icon(Icons.camera_alt))
                        : Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: Image.file(
                                state!.cover!,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                  ),
                  CustomTextForm(
                    controller: nameController,
                    label: 'Name',
                    placeholder: "Business's name",
                  ),
                  CustomTextForm(
                    controller: descriptionController,
                    label: 'Description',
                    placeholder: "Business's description",
                  ),
                  CustomPressableInput(
                    onPress: selectLocation,
                    label: 'Location',
                    suffixIcon: Icon(
                      Icons.search,
                      color: theme.colorScheme.primary,
                      size: 20,
                    ),
                    leading: Icon(
                      Icons.location_on,
                      color: theme.colorScheme.primary,
                      size: 20,
                    ),
                    child: Text(
                      state?.location == null
                          ? 'Search location'
                          : getFullAddress(state!.location!.placemark),
                      style: const TextStyle(
                        fontSize: 12,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  CustomPressableInput(
                    onPress: selectCategory,
                    label: 'Category',
                    suffixIcon: Icon(
                      Icons.add_circle_outline,
                      color: theme.colorScheme.primary,
                      size: 20,
                    ),
                    child: Text(
                      state?.category?.text ?? 'Select category',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  CustomPressableInput(
                    onPress: selectOpenHours,
                    label: 'Open hours',
                    suffixIcon: Icon(
                      Icons.add_circle_outline,
                      color: theme.colorScheme.primary,
                      size: 20,
                    ),
                    child: const Text(
                      'Edit',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  ...(state?.openHours.map(
                        (e) => OpenHourCard(
                          text: '${e.daysString()}, ${e.timeString()}',
                        ),
                      ) ??
                      []),
                  if (closedDays.isNotEmpty)
                    OpenHourCard(
                      isOpen: false,
                      text: getDays(closedDays),
                    ),
                  CustomPressableInput(
                    onPress: selectExternalLinks,
                    label: 'External links',
                    suffixIcon: Icon(
                      Icons.add_circle_outline,
                      color: theme.colorScheme.primary,
                      size: 20,
                    ),
                    child: const Text(
                      "Edit",
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  ...(state?.externalLinks.map(
                        (e) => ExternalLinkCard(externalLink: e),
                      ) ??
                      []),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
            child: Row(
              children: [
                Expanded(
                  child: PrimaryButton(
                    onPress: navigateToProducts,
                    child: const Text('Fill in products'),
                  ),
                ),
                const SizedBox(width: 8),
                SecondaryButton(
                  onPressed: submit,
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
