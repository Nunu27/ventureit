import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ventureit/controllers/location_controller.dart';

class UserLocation extends ConsumerWidget {
  const UserLocation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final location = ref.watch(locationProvider);

    return Row(
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
    );
  }
}
