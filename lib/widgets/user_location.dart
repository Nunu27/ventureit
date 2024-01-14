import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ventureit/controllers/location_controller.dart';
import 'package:ventureit/controllers/modal_controller.dart';

class UserLocation extends ConsumerWidget {
  const UserLocation({super.key});

  void selectLocation(BuildContext context, WidgetRef ref) async {
    final location = await ref
        .read(modalControllerProvider)
        .showLocationPickerSheet(context);

    if (location != null) {
      ref.read(locationProvider.notifier).update((state) => location);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final location = ref.watch(locationProvider);

    return GestureDetector(
      onTap: () => selectLocation(context, ref),
      child: Row(
        children: [
          Icon(
            Icons.location_on,
            color: theme.colorScheme.primary,
          ),
          Text(
            location == null
                ? 'Unknown'
                : '${location.placemark.subLocality}, ${location.placemark.locality}',
            style: const TextStyle(fontSize: 14),
          ),
          const Icon(Icons.expand_more),
        ],
      ),
    );
  }
}
