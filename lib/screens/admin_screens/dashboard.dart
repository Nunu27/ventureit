import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final tabPage = TabPage.of(context);
    final theme = Theme.of(context);

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
          tabs: [
            Tab(
              text: 'Submissions',
              icon: Icon(
                tabPage.controller.index == 0
                    ? Icons.book
                    : Icons.book_outlined,
              ),
              iconMargin: const EdgeInsets.all(0),
            ),
            Tab(
              text: 'Profile',
              icon: Icon(
                tabPage.controller.index == 1
                    ? Icons.person
                    : Icons.person_outlined,
              ),
              iconMargin: const EdgeInsets.all(0),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabPage.controller,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          for (final stack in tabPage.stacks) PageStackNavigator(stack: stack),
        ],
      ),
    );
  }
}
