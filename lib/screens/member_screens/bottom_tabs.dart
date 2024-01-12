import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:ventureit/controllers/location_controller.dart';
import 'package:ventureit/controllers/modal_controller.dart';
import 'package:ventureit/widgets/loader.dart';

class BottomTabs extends ConsumerStatefulWidget {
  const BottomTabs({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BottomTabsState();
}

class _BottomTabsState extends ConsumerState<BottomTabs> {
  bool isLoaded = false;
  bool waiting = true;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      ref.read(locationControllerProvider.notifier).getLocation();
      waiting = false;
    });
  }

  void showLocationPickerSheet() async {
    ref.read(modalControllerProvider).showLocationPickerSheet(context);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(locationControllerProvider);
    final location = ref.watch(locationProvider);
    final tabPage = TabPage.of(context);
    final theme = Theme.of(context);

    if (!waiting && !isLoading && !isLoaded) isLoaded = true;
    if (location == null && isLoaded) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        showLocationPickerSheet();
      });
    }

    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.background,
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.onBackground.withAlpha(64),
              blurRadius: 6,
              offset: const Offset(0, -2),
            )
          ],
        ),
        child: TabBar(
          controller: tabPage.controller,
          indicatorColor: Colors.transparent,
          dividerColor: Colors.transparent,
          tabs: [
            Tab(
              text: 'Explore',
              icon: Icon(
                tabPage.controller.index == 0
                    ? Icons.explore
                    : Icons.explore_outlined,
              ),
              iconMargin: const EdgeInsets.all(0),
            ),
            Tab(
              text: 'Missions',
              icon: Icon(
                tabPage.controller.index == 1
                    ? Icons.flag
                    : Icons.flag_outlined,
              ),
              iconMargin: const EdgeInsets.all(0),
            ),
            Tab(
              text: 'Profile',
              icon: Icon(
                tabPage.controller.index == 2
                    ? Icons.person
                    : Icons.person_outlined,
              ),
              iconMargin: const EdgeInsets.all(0),
            ),
          ],
        ),
      ),
      body: location == null
          ? const Loader()
          : TabBarView(
              controller: tabPage.controller,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                for (final stack in tabPage.stacks)
                  PageStackNavigator(stack: stack),
              ],
            ),
    );
  }
}
