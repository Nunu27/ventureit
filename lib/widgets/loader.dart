import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  final double size;
  const Loader({super.key, this.size = 30});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: size,
        width: size,
        child: CircularProgressIndicator(strokeWidth: size / 8),
      ),
    );
  }
}
