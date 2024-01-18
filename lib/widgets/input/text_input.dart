import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ventureit/widgets/input/input_form.dart';

class CustomTextForm extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final String? placeholder;
  final String? initialValue;
  final int? maxLength;
  final int? maxLines;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextForm({
    super.key,
    this.controller,
    required this.label,
    this.placeholder,
    this.maxLength,
    this.maxLines,
    this.validator,
    this.keyboardType,
    this.inputFormatters,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8),
          InputForm(
            initialValue: initialValue,
            controller: controller,
            maxLines: maxLines,
            maxLength: maxLength,
            hintText: placeholder,
            inputFormatters: inputFormatters,
          ),
        ],
      ),
    );
  }
}
