import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ventureit/widgets/input/input_form.dart';

class CustomTextForm extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final String? placeholder;
  final int? maxLength;
  final int? maxLines;
  final String? Function(String?)? validator;
  final Function(String?)? onChanged;
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
    this.onChanged,
    this.keyboardType,
    this.inputFormatters,
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
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8),
          InputForm(
            controller: controller,
            maxLines: maxLines,
            maxLength: maxLength,
            hintText: placeholder,
            inputFormatters: inputFormatters,
            keyboardType: keyboardType,
            onChanged: onChanged,
            validator: validator,
          ),
        ],
      ),
    );
  }
}
