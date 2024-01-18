import 'package:flutter/material.dart';
import 'package:ventureit/models/business/external_link.dart';
import 'package:ventureit/utils/validation.dart';
import 'package:ventureit/widgets/submission_card/external_link_card.dart';
import 'package:ventureit/widgets/primary_button.dart';
import 'package:ventureit/widgets/secondary_button.dart';

class ExternalLinksModal extends StatefulWidget {
  final List<ExternalLink> state;
  final ScrollController scrollController;

  const ExternalLinksModal({
    super.key,
    required this.state,
    required this.scrollController,
  });

  @override
  State<ExternalLinksModal> createState() => _ExternalLinksModalState();
}

class _ExternalLinksModalState extends State<ExternalLinksModal> {
  final _form = GlobalKey<FormState>();
  TextEditingController urlController = TextEditingController();

  late List<ExternalLink> current;

  @override
  void initState() {
    super.initState();
    current = List.from(widget.state);
  }

  @override
  void dispose() {
    urlController.dispose();
    super.dispose();
  }

  void add() {
    if (!_form.currentState!.validate()) return;

    final host = Uri.tryParse(urlController.text.trim())?.host;

    current.add(
      ExternalLink(
        site: linkHostname[host] ?? LinkSite.website,
        url: urlController.text.trim(),
      ),
    );
    urlController.clear();
    setState(() {});
  }

  void confirm() {
    Navigator.of(context, rootNavigator: true).pop(current);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              controller: widget.scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Fill in external links',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Form(
                    key: _form,
                    child: TextFormField(
                      controller: urlController,
                      validator: validateUrl,
                      decoration: InputDecoration(
                        hintText: 'URL',
                        filled: true,
                        fillColor: theme.colorScheme.surfaceVariant,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 8,
                        ),
                        isDense: true,
                      ),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: SecondaryButton(
                      onPressed: add,
                      child: const Text('Add'),
                    ),
                  ),
                  const SizedBox(height: 4),
                  ...current.map(
                    (e) => ExternalLinkCard(
                      externalLink: e,
                      trailing: GestureDetector(
                        onTap: () {
                          current.remove(e);
                          setState(() {});
                        },
                        child: const Icon(
                          Icons.delete,
                          color: Colors.red,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: PrimaryButton(
              onPress: confirm,
              child: const Text('Confirm'),
            ),
          )
        ],
      ),
    );
  }
}
