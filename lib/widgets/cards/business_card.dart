import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:ventureit/controllers/location_controller.dart';
import 'package:ventureit/models/business/business.dart';

class BusinessCard extends ConsumerWidget {
  final Business business;

  const BusinessCard({super.key, required this.business});

  void navigateToDetail(BuildContext context) {
    Routemaster.of(context).push('/member/business/${business.id}');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = ref.watch(locationProvider)!;
    final openHour = business.getOpenHours();
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(4),
      child: InkWell(
        onTap: () => navigateToDetail(context),
        child: Container(
          height: 80,
          decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  business.cover,
                  fit: BoxFit.cover,
                  height: 80,
                  width: 80,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    business.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    business.getDistance(location.position),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 14,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  business.rating.toString(),
                                  style: const TextStyle(fontSize: 10),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      openHour == null
                          ? const Text(
                              'Closed',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            )
                          : RichText(
                              text: TextSpan(
                                style: const TextStyle(fontSize: 12),
                                children: [
                                  openHour.isOpen()
                                      ? const TextSpan(
                                          text: 'Open  ',
                                          style: TextStyle(color: Colors.green),
                                        )
                                      : const TextSpan(
                                          text: 'Closed  ',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                  TextSpan(
                                    text: openHour.toString(),
                                    style: TextStyle(
                                        color: theme
                                            .colorScheme.onPrimaryContainer),
                                  ),
                                ],
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
