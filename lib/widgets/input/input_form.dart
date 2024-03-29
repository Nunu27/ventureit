import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputForm extends StatelessWidget {
  const InputForm({
    super.key,
    this.controller,
    this.keyboardType,
    this.hintText,
    this.validator,
    this.suffixIcon,
    this.inputFormatters,
    this.maxLength,
    this.maxLines = 1,
    this.obscureText = false,
    this.onChanged,
    this.contentPadding,
    this.initialValue,
  });

  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? hintText;
  final String? initialValue;
  final String? Function(String?)? validator;
  final Function(String?)? onChanged;
  final bool obscureText;
  final Widget? suffixIcon;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final int? maxLines;
  final EdgeInsetsGeometry? contentPadding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      initialValue: initialValue,
      maxLength: maxLength,
      maxLines: maxLines,
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      style: TextStyle(
        color: theme.colorScheme.onSurfaceVariant,
        fontSize: 12,
      ),
      onChanged: onChanged,
      decoration: InputDecoration(
        filled: true,
        isDense: true,
        isCollapsed: true,
        hintText: hintText,
        suffixIcon: suffixIcon,
        fillColor: theme.colorScheme.surfaceVariant,
        hintStyle: TextStyle(
          color: theme.colorScheme.onSurfaceVariant,
          fontSize: 12,
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(28),
          ),
          borderSide: BorderSide.none,
        ),
        contentPadding: contentPadding ??
            const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      ),
    );
  }
}
