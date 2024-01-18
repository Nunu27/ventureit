import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ventureit/controllers/modal_controller.dart';
import 'package:ventureit/models/business/business.dart';
import 'package:ventureit/providers/edit_business_provider.dart';
import 'package:ventureit/utils/location_utils.dart';
import 'package:ventureit/utils/picker.dart';
import 'package:ventureit/utils/utils.dart';
import 'package:ventureit/widgets/input/pressable_input.dart';
import 'package:ventureit/widgets/input/text_input.dart';
import 'package:ventureit/widgets/loader.dart';
import 'package:ventureit/widgets/primary_button.dart';
import 'package:ventureit/widgets/submission_card/open_hours_card.dart';

class GeneralEditBusiness extends ConsumerStatefulWidget {
  final String id;
  const GeneralEditBusiness({super.key, required this.id});

  @override
  ConsumerState<GeneralEditBusiness> createState() =>
      _GeneralEditBusinessState();
}

class _GeneralEditBusinessState extends ConsumerState<GeneralEditBusiness> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;

  EditBusinessState? state;
  List<MapEntry<int, String>> closedDays = [];
  Business? business;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      state = ref.read(editBusinessProvider);

      nameController = TextEditingController(text: state!.name);
      descriptionController = TextEditingController(text: state!.description);
      closedDays = getClosedDays(state!.openHours);
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
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

    if (category != null) {
      state!.category = category;
      setState(() {});
    }
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

  void submit() {}

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final media = MediaQuery.of(context);

    return isLoading
        ? const Loader()
        : SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Cover Image",
                    style: TextStyle(
                      fontSize: 16,
                      color: theme.colorScheme.onBackground,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    width: media.size.width - 36,
                    height: 200,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: state!.cover == null
                          ? Image.network(
                              state!.reference.cover,
                              fit: BoxFit.cover,
                            )
                          : Image.file(
                              state!.cover!,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: PrimaryButton(
                      onPress: selectCover,
                      child: const Text("Edit"),
                    ),
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  CustomTextForm(
                    controller: nameController,
                    label: "Name",
                  ),
                  CustomTextForm(
                    controller: descriptionController,
                    label: "Description",
                  ),
                  CustomPressableInput(
                    onPress: selectLocation,
                    label: "Location",
                    suffixIcon: Icon(
                      Icons.search,
                      color: theme.colorScheme.primary,
                    ),
                    leading: Icon(
                      Icons.location_on,
                      color: theme.colorScheme.primary,
                    ),
                    child: Text(
                      getFullAddress(state!.location.placemark),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  CustomPressableInput(
                    onPress: selectCategory,
                    label: "Category",
                    suffixIcon: Icon(
                      Icons.edit,
                      size: 20,
                      color: theme.colorScheme.primary,
                    ),
                    child: Text(
                      state!.category.text,
                      style: TextStyle(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    "Open hours",
                    style: TextStyle(
                      fontSize: 16,
                      color: theme.colorScheme.onBackground,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  ...(state!.reference.openHours.map(
                    (e) => OpenHourCard(
                      text: '${e.daysString()}, ${e.timeString()}',
                    ),
                  )),
                  if (closedDays.isNotEmpty)
                    OpenHourCard(
                      isOpen: false,
                      text: getDays(closedDays),
                    ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: PrimaryButton(
                      onPress: selectOpenHours,
                      child: const Text("Edit"),
                    ),
                  ),
                  CustomPressableInput(
                    onPress: () {},
                    label: "External link",
                    child: Text(
                      state!.reference.externalLinks[0].url,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: PrimaryButton(
                      onPress: selectExternalLinks,
                      child: const Text("Edit"),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
