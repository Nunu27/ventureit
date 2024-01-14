import 'package:flutter/material.dart';

class EndOfList extends StatelessWidget {
  const EndOfList({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 20,
      child: Center(
        child: Text('End of list reached'),
      ),
    );
  }
}
