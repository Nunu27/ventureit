import 'package:flutter/material.dart';

class CustomDropdown<T> extends StatelessWidget {
  final TextEditingController? controller;
  final T? initialSelection;
  final String? hintText;
  final List<DropdownMenuEntry<T>> entries;
  final void Function(T?)? onSelected;
  final double? width;

  const CustomDropdown({
    super.key,
    this.controller,
    this.initialSelection,
    this.hintText,
    required this.entries,
    this.onSelected,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DropdownMenu(
      controller: controller,
      initialSelection: initialSelection,
      onSelected: onSelected,
      width: width,
      inputDecorationTheme: InputDecorationTheme(
        constraints: BoxConstraints.tight(
          const Size.fromHeight(40),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18),
        isDense: true,
        filled: true,
        fillColor: theme.colorScheme.surfaceVariant,
      ),
      hintText: hintText,
      textStyle: const TextStyle(fontSize: 12),
      dropdownMenuEntries: entries,
    );
  }
}
