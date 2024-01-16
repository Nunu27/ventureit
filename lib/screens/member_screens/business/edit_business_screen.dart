import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class EditBusinessScreen extends ConsumerStatefulWidget {
  final String businessId;
  const EditBusinessScreen({
    super.key,
    required this.businessId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditBusinessScreenState();
}

class _EditBusinessScreenState extends ConsumerState<EditBusinessScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tabPage = TabPage.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Business",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onBackground,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.done,
              size: 24,
              color: theme.colorScheme.onBackground,
            ),
          ),
        ],
        bottom: TabBar(
          controller: tabPage.controller,
          isScrollable: true,
          tabs: const [
            Tab(
              text: 'General',
            ),
            Tab(
              text: 'Products',
            ),
            Tab(
              text: 'Contents',
            ),
          ],
        ),
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
