import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:ventureit/controllers/business_controller.dart';
import 'package:ventureit/controllers/submission_controller.dart';
import 'package:ventureit/models/business/business.dart';
import 'package:ventureit/providers/edit_business_provider.dart';
import 'package:ventureit/utils/utils.dart';

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
  EditBusinessState? state;
  Business? business;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      EditBusinessState? stateData = ref.read(editBusinessProvider);
      business = ref.read(getBusinessByIdProvider(widget.businessId)).value;
      if (stateData == null && business != null) {
        stateData = EditBusinessState(business!);
        ref.read(editBusinessProvider.notifier).update((state) => stateData);
      }

      state = stateData;

      setState(() {});
    });
  }

  void submit() async {
    if (state != null) {
      FocusManager.instance.primaryFocus?.unfocus();
      ref
          .read(submissionControllerProvider.notifier)
          .addEditSubmission(data: state!, context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tabPage = TabPage.of(context);

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (!didPop) {
          FocusManager.instance.primaryFocus?.unfocus();
          if (await showDiscardData(context, ref)) {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.of(context).pop();
            });
          }
        }
      },
      child: Scaffold(
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
            for (final stack in tabPage.stacks)
              PageStackNavigator(stack: stack),
          ],
        ),
      ),
    );
  }
}
