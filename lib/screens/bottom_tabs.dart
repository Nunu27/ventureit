import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

class BottomTabs extends StatelessWidget {
  const BottomTabs({super.key});

  @override
  Widget build(BuildContext context) {
    final tabPage = TabPage.of(context);

    return Scaffold(
      bottomNavigationBar: TabBar(
        controller: tabPage.controller,
        indicatorColor: Colors.transparent,
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
              tabPage.controller.index == 1 ? Icons.flag : Icons.flag_outlined,
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
      body: TabBarView(
        controller: tabPage.controller,
        children: [
          for (final stack in tabPage.stacks) PageStackNavigator(stack: stack),
        ],
      ),
    );
  }
}
