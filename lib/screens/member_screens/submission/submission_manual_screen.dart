import 'package:flutter/material.dart';

class SubmissionManualScreen extends StatelessWidget {
  const SubmissionManualScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Submission Manual'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(20),
        child: Text('Long text explaining the submission process'),
      ),
    );
  }
}
