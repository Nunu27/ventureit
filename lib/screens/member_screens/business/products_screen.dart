import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ventureit/controllers/business_controller.dart';
import 'package:ventureit/widgets/cards/product_card.dart';
import 'package:ventureit/widgets/error_view.dart';
import 'package:ventureit/widgets/loader.dart';

class ProductsScreen extends ConsumerWidget {
  final String id;
  const ProductsScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(getBusinessByIdProvider(id)).when(
          data: (business) => ListView.builder(
            padding: EdgeInsets.all(14),
            itemCount: business.products.length,
            itemBuilder: (context, index) =>
                ProductCard(product: business.products[index]),
          ),
          error: (error, stackTrace) => ErrorView(error: error.toString()),
          loading: () => const Loader(),
        );
  }
}
