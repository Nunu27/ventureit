import 'package:flutter/material.dart';

class Rating extends StatelessWidget {
  final double rating;
  final double scale;
  const Rating(
    this.rating, {
    super.key,
    this.scale = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.star,
          color: Colors.amber,
          size: 14 * scale,
        ),
        const SizedBox(width: 4),
        Text(
          rating.toStringAsFixed(1),
          style: TextStyle(fontSize: 10 * scale),
        )
      ],
    );
  }
}
