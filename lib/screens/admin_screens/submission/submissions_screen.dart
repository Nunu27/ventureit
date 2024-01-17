import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:ventureit/controllers/submission_controller.dart';
import 'package:ventureit/widgets/error_view.dart';
import 'package:ventureit/widgets/loader.dart';

class SubmissionsScreen extends ConsumerWidget {
  const SubmissionsScreen({super.key});

  void navigateToSubmissionScreen(BuildContext context, String id) {
    Routemaster.of(context).push('/admin/submission/$id');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(getPendingSubmissionsProvider).when(
          data: (submissions) => Scaffold(
            appBar: AppBar(
              title: const Text('Submissions'),
            ),
            body: ListView.builder(
              itemCount: submissions.length,
              itemBuilder: (context, index) {
                final submission = submissions[index];

                return ListTile(
                  onTap: () =>
                      navigateToSubmissionScreen(context, submission.id),
                  title: Text(submission.id),
                  subtitle: Text(submission.status.name),
                );
              },
            ),
          ),
          error: (error, stackTrace) {
            print(stackTrace);
            return ErrorView(error: error.toString());
          },
          loading: () => const Loader(),
        );
  }
}
