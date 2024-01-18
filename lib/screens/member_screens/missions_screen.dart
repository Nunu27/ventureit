import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ventureit/constants/constants.dart';
import 'package:ventureit/controllers/auth_controller.dart';
import 'package:ventureit/controllers/location_controller.dart';
import 'package:ventureit/controllers/mission_controller.dart';
import 'package:ventureit/utils/utils.dart';
import 'package:ventureit/widgets/cards/mission_card.dart';
import 'package:ventureit/widgets/error_view.dart';
import 'package:ventureit/widgets/loader.dart';
import 'package:ventureit/widgets/loader_overlay.dart';

class MissionsScreen extends ConsumerStatefulWidget {
  const MissionsScreen({super.key});

  @override
  ConsumerState<MissionsScreen> createState() => _MissionsScreenState();
}

class _MissionsScreenState extends ConsumerState<MissionsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkGuest(context);
      ref.invalidate(getBusinessWithMissionProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final location = ref.watch(locationProvider);
    final user = ref.watch(userProvider);
    final isLoading = ref.watch(missionControllerProvider);

    return LoaderOverlay(
      isLoading: isLoading,
      child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 100,
            scrolledUnderElevation: 0,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.fmd_good_sharp,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      location == null
                          ? 'Unknown'
                          : '${location.placemark.subLocality}, ${location.placemark.locality}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.wallet,
                          color: Colors.green,
                          size: 36,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          "Rp. ${numberFormatter.format(user?.balance ?? 0)}",
                          style: const TextStyle(
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        user?.avatar ?? Constants.defaultAvatar,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          body: user ==null ? const SizedBox() : ref.watch(getBusinessWithMissionProvider).when(
                data: (businessesId) => businessesId.isEmpty
                    ? const Center(
                        child: Text('No available missions'),
                      )
                    : ref
                        .watch(fetchMissionsByBusinessesIdProvider(businessesId))
                        .when(
                          data: (missions) => missions.isEmpty
                              ? const Center(
                                  child: Text('No available missions'),
                                )
                              : SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.all(18),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'You have ${missions.length} mission nearby',
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 14,
                                      ),
                                      ...missions.map(
                                        (mission) =>
                                            MissionCard(mission: mission),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          error: (error, stackTrace) =>
                              ErrorView(error: error.toString()),
                          loading: () => const Loader(),
                        ),
                error: (error, stackTrace) => ErrorView(error: error.toString()),
                loading: () => const Loader(),
              )),
    );
  }
}
