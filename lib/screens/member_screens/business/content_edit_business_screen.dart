import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ventureit/providers/api_provider.dart';
import 'package:ventureit/providers/edit_business_provider.dart';
import 'package:ventureit/utils/validation.dart';
import 'package:ventureit/widgets/input/text_input.dart';
import 'package:ventureit/widgets/loader.dart';
import 'package:ventureit/widgets/secondary_button.dart';
import 'package:ventureit/widgets/submission_card/content_card.dart';

class ContentEditBusiness extends ConsumerStatefulWidget {
  final String id;
  const ContentEditBusiness({super.key, required this.id});

  @override
  ConsumerState<ContentEditBusiness> createState() =>
      _ContentEditBusinessState();
}

class _ContentEditBusinessState extends ConsumerState<ContentEditBusiness> {
  EditBusinessState? state;
  bool isLoading = true;
  final _form = GlobalKey<FormState>();
  final TextEditingController linkController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      state = ref.read(editBusinessProvider);

      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    linkController.dispose();
    super.dispose();
  }

  void add() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!_form.currentState!.validate()) return;
    final content = await ref
        .read(apiProvider.notifier)
        .getContentData(linkController.text);

    if (content == null) return;
    state!.contents.add(content);
    linkController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Loader()
        : SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Form(
                    key: _form,
                    child: CustomTextForm(
                      controller: linkController,
                      validator: validateUrl,
                      label: "Link",
                      placeholder: "content related to this business",
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: SecondaryButton(
                      onPressed: add,
                      child: const Text("Add"),
                    ),
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  ...state!.contents.map(
                    (content) => SubmissionContentCard(
                      content: content,
                      trailing: IconButton(
                        onPressed: () {
                          state!.contents.remove(content);
                          setState(() {});
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
