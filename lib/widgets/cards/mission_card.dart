import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:ventureit/controllers/auth_controller.dart';
import 'package:ventureit/controllers/mission_controller.dart';
import 'package:ventureit/models/mission.dart';
import 'package:ventureit/utils/utils.dart';
import 'package:ventureit/widgets/remote_image.dart';

class MissionCard extends ConsumerWidget {
  final Mission mission;
  const MissionCard({super.key, required this.mission});

  void navigateToBusiness(BuildContext context) {
    Routemaster.of(context).push('/member/business/${mission.businessId}');
  }

  void claim(WidgetRef ref) {
    ref.read(missionControllerProvider.notifier).claim(mission);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final claimed = mission.claimedBy.contains(user?.id);
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(4),
      child: GestureDetector(
        onTap: claimed ? null : () => navigateToBusiness(context),
        child: Container(
          height: 80,
          decoration: BoxDecoration(
              color: claimed
                  ? theme.colorScheme.secondaryContainer
                  : theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Stack(children: [
                  RemoteImage(
                    url: mission.businessCover,
                    fit: BoxFit.cover,
                    height: 80,
                    width: 80,
                  ),
                  if (claimed)
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.secondary.withOpacity(0.5),
                      ),
                    ),
                ]),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        mission.type.instruction,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: claimed
                              ? theme.colorScheme.onSecondaryContainer
                              : theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            mission.businessName,
                            style: TextStyle(
                              fontSize: 12,
                              color: claimed
                                  ? theme.colorScheme.onSecondaryContainer
                                  : theme.colorScheme.onPrimaryContainer,
                            ),
                          ),
                          Text(
                            "Rp. ${numberFormatter.format(mission.type.reward)}",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      SizedBox(
                        height: 20,
                        child: Row(
                          children: [
                            Expanded(
                              child: Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: (claimed
                                              ? theme.colorScheme.secondary
                                              : theme.colorScheme.primary)
                                          .withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  FractionallySizedBox(
                                    widthFactor: mission.finishedCount /
                                        mission.maxQuota,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: claimed
                                            ? theme.colorScheme.secondary
                                            : theme.colorScheme.primary,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "${mission.maxQuota - mission.finishedCount} Left",
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                        color: claimed
                                            ? theme.colorScheme.onSecondary
                                            : theme.colorScheme.onPrimary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: claimed
                                    ? theme.colorScheme.secondary
                                    : theme.colorScheme.primary,
                                foregroundColor: claimed
                                    ? theme.colorScheme.onPrimary
                                    : theme.colorScheme.onPrimary,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                              ),
                              onPressed: claimed ? null : () => claim(ref),
                              child: Text(
                                mission.claimedBy.contains(user?.id)
                                    ? "Claimed"
                                    : "Claim",
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
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
