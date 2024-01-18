import 'package:flutter/material.dart';
import 'package:ventureit/providers/add_submission_provider.dart';
import 'package:ventureit/utils/utils.dart';
import 'package:ventureit/widgets/remote_image.dart';

class ProductCard extends StatelessWidget {
  final SubmissionProductItem product;
  final Widget? trailing;

  const ProductCard({
    super.key,
    required this.product,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      height: 70,
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: product.pictureUrl == null
                ? Image.file(
                    product.picture!,
                    height: 70,
                    width: 70,
                    fit: BoxFit.cover,
                  )
                : RemoteImage(
                    url: product.pictureUrl!,
                    height: 70,
                    width: 70,
                    fit: BoxFit.cover,
                  ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(product.name),
                  Text(
                    'Rp. ${numberFormatter.format(product.price)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          if (trailing != null) trailing!
        ],
      ),
    );
  }
}
