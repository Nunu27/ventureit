import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextForm extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final String? placeholder;
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
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
          TextFormField(
            controller: controller,
            style: const TextStyle(fontSize: 12),
            maxLength: maxLength,
            maxLines: maxLines,
            validator: validator,
            inputFormatters: inputFormatters,
            decoration: InputDecoration(
              hintText: placeholder,
              filled: true,
              fillColor: theme.colorScheme.surfaceVariant,
              isDense: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none,
              ),
            ),
          )
        ],
      ),
    );
  }
}
