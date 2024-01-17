import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ventureit/controllers/business_controller.dart';
import 'package:ventureit/utils/utils.dart';
import 'package:ventureit/widgets/error_view.dart';
import 'package:ventureit/widgets/loader.dart';

class DetailsScreen extends ConsumerWidget {
  final String id;
  const DetailsScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(getBusinessByIdProvider(id)).when(
          data: (business) => Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'External link',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                ...business.externalLinks.map(
                  (externalLink) => Row(
                    children: [
                      Image.asset(
                        externalLink.site.logo,
                        height: 24,
                        width: 24,
                      ),
                      GestureDetector(
                        onTap: () => openUrl(externalLink.url),
                        child: Text(
                          externalLink.site.source,
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Description',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(business.description ?? 'No description yet'),
                const SizedBox(height: 16),
                const Text(
                  'Open hours',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                ...business.openHours.map(
                  (openHour) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        openHour.daysString(),
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        openHour.timeString(),
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          error: (error, stackTrace) => ErrorView(error: error.toString()),
          loading: () => const Loader(),
        );
  }
}
