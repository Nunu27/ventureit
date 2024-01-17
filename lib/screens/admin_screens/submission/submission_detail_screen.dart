import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ventureit/controllers/submission_controller.dart';
import 'package:ventureit/models/submission/submission.dart';
import 'package:ventureit/widgets/error_view.dart';
import 'package:ventureit/widgets/loader.dart';
import 'package:ventureit/widgets/loader_overlay.dart';
import 'package:ventureit/widgets/primary_button.dart';

class SubmissionDetailScreen extends ConsumerWidget {
  final String id;
  const SubmissionDetailScreen({super.key, required this.id});

  void approve(BuildContext context, WidgetRef ref, Submission submission) {
    ref
        .read(submissionControllerProvider.notifier)
        .approve(context, submission);
  }

  void reject(BuildContext context, WidgetRef ref, Submission submission) {
    ref.read(submissionControllerProvider.notifier).reject(context, submission);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(submissionControllerProvider);

    return ref.watch(getSubmissionByIdProvider(id)).when(
          data: (submission) => LoaderOverlay(
            isLoading: isLoading,
            child: Scaffold(
              appBar: AppBar(
                title: Text('Submission Detail'),
              ),
              body: Padding(
                padding: EdgeInsets.all(18),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PrimaryButton(
                      onPress: () {
                        approve(context, ref, submission);
                      },
                      child: Text('Approve'),
                    ),
                    PrimaryButton(
                      onPress: () {
                        reject(context, ref, submission);
                      },
                      child: Text('Reject'),
                    )
                  ],
                ),
              ),
            ),
          ),
          error: (error, stackTrace) => ErrorView(error: error.toString()),
          loading: () => Loader(),
        );
  }
}
