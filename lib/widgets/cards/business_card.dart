import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:ventureit/controllers/location_controller.dart';
import 'package:ventureit/models/business/business_basic.dart';
import 'package:ventureit/widgets/error_view.dart';
import 'package:ventureit/widgets/loader.dart';
import 'package:ventureit/widgets/remote_image.dart';

final currentBusinessCardProvider = Provider<AsyncValue<BusinessBasic>>((ref) {
  throw UnimplementedError();
});

class BusinessCard extends ConsumerWidget {
  final bool isBorder;
  final bool openNow;

  const BusinessCard({super.key, this.isBorder = false, this.openNow = false});

  void navigateToDetail(BuildContext context, String id) {
    Routemaster.of(context).push('/member/business/$id');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = ref.watch(locationProvider)!;
    final theme = Theme.of(context);

    return ref.watch(currentBusinessCardProvider).when(
          data: (business) {
            final openHour = business.getOpenHours();
            if (openNow && (openHour == null || !openHour.isOpen())) {
              return const SizedBox();
            }

            return Padding(
              padding: const EdgeInsets.all(4),
              child: GestureDetector(
                onTap: () => navigateToDetail(context, business.id),
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
                        child: RemoteImage(
                          url: business.cover,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            business.name,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            business
                                                .getDistance(location.position),
                                            style:
                                                const TextStyle(fontSize: 12),
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
                                                  style: TextStyle(
                                                      color: Colors.green),
                                                )
                                              : const TextSpan(
                                                  text: 'Closed  ',
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                ),
                                          TextSpan(
                                            text: openHour.timeString(),
                                            style: TextStyle(
                                                color: theme.colorScheme
                                                    .onPrimaryContainer),
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
          },
          error: (error, stackTrace) => isBorder
              ? SizedBox(height: 80, child: ErrorView(error: error.toString()))
              : const SizedBox(),
          loading: () => isBorder
              ? const SizedBox(height: 80, child: Loader())
              : const SizedBox(),
        );
  }
}
