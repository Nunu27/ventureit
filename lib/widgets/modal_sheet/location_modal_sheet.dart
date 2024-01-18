import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ventureit/controllers/location_controller.dart';
import 'package:ventureit/controllers/modal_controller.dart';
import 'package:ventureit/models/location.dart';
import 'package:ventureit/utils/location_utils.dart';
import 'package:ventureit/widgets/loader_overlay.dart';
import 'package:ventureit/widgets/primary_button.dart';

class LocationModalSheet extends ConsumerStatefulWidget {
  const LocationModalSheet({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _LocationModalSheetState();
}

class _LocationModalSheetState extends ConsumerState<LocationModalSheet> {
  LocationModel? locationPick;

  void getLocation() async {
    if (await ref
        .read(locationControllerProvider.notifier)
        .getLocation(force: true)) {
      closeModal();
    }
  }

  void openLocationPicker() async {
    final newLocation = await ref
        .read(modalControllerProvider)
        .showLocationPickerSheet(context);

    if (newLocation != null) {
      setState(() {
        locationPick = newLocation;
      });
    }
  }

  void closeModal() {
    Navigator.of(context, rootNavigator: true).pop();
  }

  void confirm() {
    if (locationPick != null) {
      ref.read(locationProvider.notifier).update((state) => locationPick);
    }

    closeModal();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(locationControllerProvider);
    final theme = Theme.of(context);

    return SizedBox(
      height: 300,
      child: LoaderOverlay(
        isLoading: isLoading,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  height: 5,
                  width: 30,
                  decoration: BoxDecoration(
                    color: theme.dividerColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Select location',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_off),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Turn on location?',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'This will give you the best recommendation',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 1,
                        ),
                      ),
                      onPressed: getLocation,
                      child: const Text('Turn on'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: openLocationPicker,
                style: OutlinedButton.styleFrom(
                  foregroundColor: theme.colorScheme.onBackground,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        locationPick?.placemark == null
                            ? 'Search location'
                            : getFullAddress(locationPick!.placemark),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Icon(Icons.search),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              PrimaryButton(
                onPress: locationPick == null ? null : confirm,
                child: const Row(
                  children: [Text("Confirm")],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
