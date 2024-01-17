import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:ventureit/controllers/submission_controller.dart';
import 'package:ventureit/providers/add_submission_provider.dart';
import 'package:ventureit/providers/api_provider.dart';
import 'package:ventureit/utils/validation.dart';
import 'package:ventureit/widgets/input/text_input.dart';
import 'package:ventureit/widgets/loader_overlay.dart';
import 'package:ventureit/widgets/primary_button.dart';
import 'package:ventureit/widgets/secondary_button.dart';
import 'package:ventureit/widgets/submission_card/content_card.dart';

class AddSubmissionContents extends ConsumerStatefulWidget {
  const AddSubmissionContents({super.key});

  @override
  ConsumerState<AddSubmissionContents> createState() =>
      _AddSubmissionContentsState();
}

class _AddSubmissionContentsState extends ConsumerState<AddSubmissionContents> {
  final _form = GlobalKey<FormState>();
  final TextEditingController linkController = TextEditingController();
  late AddSubmissionState state;

  @override
  void initState() {
    super.initState();
    state = ref.read(addSubmissionProvider)!;
  }

  @override
  void dispose() {
    linkController.dispose();
    super.dispose();
  }

  void goBack() {
    Routemaster.of(context).history.back();
  }

  void add() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!_form.currentState!.validate()) return;
    final content = await ref
        .read(apiProvider.notifier)
        .getContentData(linkController.text);

    if (content == null) return;
    state.contents.tiktok.add(content);
    linkController.clear();
  }

  void submit() async {
    FocusManager.instance.primaryFocus?.unfocus();
    ref
        .read(submissionControllerProvider.notifier)
        .addEntrySubmission(data: state, context: context);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading =
        ref.watch(apiProvider) || ref.watch(submissionControllerProvider);

    return LoaderOverlay(
      isLoading: isLoading,
      child: Scaffold(
        appBar: AppBar(
          forceMaterialTransparency: true,
          title: const Text('Add business contents'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18.0).copyWith(top: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  child: const Row(
                    children: [
                      Icon(Icons.info_outline),
                      SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          'You can fill in  social media content if you know about this business.',
                        ),
                      ),
                    ],
                  ),
                ),
                Form(
                  key: _form,
                  child: CustomTextForm(
                    controller: linkController,
                    label: 'Link',
                    validator: validateUrl,
                    maxLines: 1,
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: SecondaryButton(
                    onPressed: add,
                    child: const Text('Add'),
                  ),
                ),
                const SizedBox(height: 10),
                ...state.contents.tiktok.map((e) => SubmissionContentCard(
                      content: e,
                      trailing: IconButton(
                        onPressed: () {
                          state.contents.tiktok.remove(e);
                          setState(() {});
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                    ))
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
          child: Row(
            children: [
              SecondaryButton(
                onPressed: goBack,
                child: const Text('Back'),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: PrimaryButton(
                  onPress: submit,
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
