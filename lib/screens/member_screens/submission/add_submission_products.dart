import 'dart:io';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:ventureit/controllers/submission_controller.dart';
import 'package:ventureit/providers/add_submission_provider.dart';
import 'package:ventureit/utils/picker.dart';
import 'package:ventureit/utils/utils.dart';
import 'package:ventureit/utils/validation.dart';
import 'package:ventureit/widgets/input/pressable_input.dart';
import 'package:ventureit/widgets/input/text_input.dart';
import 'package:ventureit/widgets/loader_overlay.dart';
import 'package:ventureit/widgets/primary_button.dart';
import 'package:ventureit/widgets/secondary_button.dart';
import 'package:ventureit/widgets/submission_card/product_card.dart';

class AddSubmissionProducts extends ConsumerStatefulWidget {
  const AddSubmissionProducts({super.key});

  @override
  ConsumerState<AddSubmissionProducts> createState() =>
      _AddSubmissionProductsState();
}

class _AddSubmissionProductsState extends ConsumerState<AddSubmissionProducts> {
  final _form = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  File? picture;

  late AddSubmissionState state;

  @override
  void initState() {
    super.initState();
    state = ref.read(addSubmissionProvider)!;
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    super.dispose();
  }

  void selectPicture() async {
    final res = await pickImage();
    if (res == null) return;

    setState(() {
      picture = File(res.files.first.path!);
    });
  }

  void navigateToContents() {
    Routemaster.of(context).push('/member/add-submission/contents');
  }

  void add() {
    if (!_form.currentState!.validate()) return;
    if (picture == null) {
      showSnackBar("Please select the product picture");
      return;
    }

    state.products.add(
      SubmissionProductItem(
        name: nameController.text,
        price: int.parse(priceController.text.replaceAll(RegExp(r'[^\d]'), '')),
        picture: picture,
      ),
    );
    nameController.clear();
    priceController.clear();
    setState(() {
      picture = null;
    });
  }

  void submit() async {
    FocusManager.instance.primaryFocus?.unfocus();
    ref
        .read(submissionControllerProvider.notifier)
        .addEntrySubmission(data: state, context: context);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(submissionControllerProvider);

    return LoaderOverlay(
      isLoading: isLoading,
      child: Scaffold(
        appBar: AppBar(
          forceMaterialTransparency: true,
          title: const Text('Add business products'),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _form,
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
                            'You can fill in the product if you know the product list or you can skip this step.',
                          ),
                        ),
                      ],
                    ),
                  ),
                  CustomTextForm(
                    controller: nameController,
                    label: 'Name',
                    placeholder: 'Product name',
                    validator: validateUsername,
                  ),
                  CustomTextForm(
                    controller: priceController,
                    label: 'Price',
                    placeholder: 'Product price',
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      CurrencyTextInputFormatter(
                        locale: 'id',
                        decimalDigits: 0,
                        symbol: 'Rp. ',
                      ),
                    ],
                  ),
                  CustomPressableInput(
                    label: 'Product image',
                    onPress: selectPicture,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 18.0),
                      child: Text(
                        picture?.path ?? 'Select picture',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: SecondaryButton(
                      onPressed: add,
                      child: const Text('Add'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...state.products.map((e) => ProductCard(
                        product: e,
                        trailing: IconButton(
                          onPressed: () {
                            state.products.remove(e);
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
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
          child: Row(
            children: [
              Expanded(
                child: PrimaryButton(
                  onPress: navigateToContents,
                  child: const Text('Fill in contents'),
                ),
              ),
              const SizedBox(width: 8),
              SecondaryButton(
                onPressed: submit,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
