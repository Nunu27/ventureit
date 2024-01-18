import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ventureit/providers/add_submission_provider.dart';
import 'package:ventureit/providers/edit_business_provider.dart';
import 'package:ventureit/utils/picker.dart';
import 'package:ventureit/utils/utils.dart';
import 'package:ventureit/widgets/input/pressable_input.dart';
import 'package:ventureit/widgets/input/text_input.dart';
import 'package:ventureit/widgets/loader.dart';
import 'package:ventureit/widgets/secondary_button.dart';
import 'package:ventureit/widgets/submission_card/product_card.dart';

class ProductsEditBusiness extends ConsumerStatefulWidget {
  final String id;

  const ProductsEditBusiness({
    super.key,
    required this.id,
  });

  @override
  ConsumerState<ProductsEditBusiness> createState() =>
      _ProductsEditBusinessState();
}

class _ProductsEditBusinessState extends ConsumerState<ProductsEditBusiness> {
  EditBusinessState? state;
  bool isLoading = true;
  File? picture;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final _form = GlobalKey<FormState>();

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

  void add() {
    if (!_form.currentState!.validate()) return;
    if (picture == null) {
      showSnackBar("Please select the product picture");
      return;
    }

    if (state != null) {
      state!.newProducts.add(
        SubmissionProductItem(
          name: nameController.text,
          price:
              int.parse(priceController.text.replaceAll(RegExp(r'[^\d]'), '')),
          picture: picture,
        ),
      );
      nameController.clear();
      priceController.clear();
      setState(() {
        picture = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return isLoading
        ? const Loader()
        : Form(
            key: _form,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextForm(
                      controller: nameController,
                      label: "Name",
                      placeholder: "Name",
                    ),
                    CustomTextForm(
                      controller: priceController,
                      label: 'Price',
                      placeholder: 'Product price',
                      keyboardType: TextInputType.number,
                      inputFormatters: [currencyFormatter],
                    ),
                    CustomPressableInput(
                      onPress: selectPicture,
                      label: "Product image",
                      suffixIcon: Icon(
                        Icons.upload,
                        color: theme.colorScheme.primary,
                      ),
                      child: Text(
                        picture?.path ?? 'Select picture',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: SecondaryButton(
                        onPressed: add,
                        child: const Text("Add"),
                      ),
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    ...state!.newProducts.map(
                      (product) => ProductCard(
                        product: product,
                        trailing: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                nameController.clear();
                                priceController.clear();

                                nameController.text = product.name;
                                priceController.text = currencyFormatter
                                    .format(product.price.toString());

                                state!.newProducts.remove(product);
                                setState(() {});
                              },
                              icon: Icon(
                                Icons.edit,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                state!.newProducts.remove(product);
                                setState(() {});
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ...state!.reference.products.map(
                      (product) => state!.removedProducts.contains(product)
                          ? const SizedBox()
                          : ProductCard(
                              product: product.toSubmissionProduct(),
                              trailing: Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      nameController.clear();
                                      priceController.clear();

                                      nameController.text = product.name;
                                      priceController.text = currencyFormatter
                                          .format(product.price.toString());

                                      state!.removedProducts.add(product);
                                      setState(() {});
                                    },
                                    icon: Icon(
                                      Icons.edit,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      state!.removedProducts.add(product);
                                      setState(() {});
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
