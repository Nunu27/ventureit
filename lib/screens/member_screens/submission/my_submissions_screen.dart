import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ventureit/controllers/auth_controller.dart';
import 'package:ventureit/controllers/submission_controller.dart';
import 'package:ventureit/widgets/error_view.dart';
import 'package:ventureit/widgets/loader.dart';

class MySubmissionsScreen extends ConsumerWidget {
  const MySubmissionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;

    return ref.watch(getSubmissionByUserIdProvider(user.id)).when(
          data: (submissions) => Scaffold(
            appBar: AppBar(
              title: const Text('My Submissions'),
            ),
            body: ListView.builder(
              itemCount: submissions.length,
              itemBuilder: (context, index) {
                final submission = submissions[index];
                return ListTile(
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
          loading: () => Loader(),
        );
  }
}
