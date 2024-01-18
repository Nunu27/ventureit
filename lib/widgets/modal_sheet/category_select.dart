import 'package:flutter/material.dart';
import 'package:ventureit/models/business/business.dart';
import 'package:ventureit/widgets/primary_button.dart';

class CategorySelectModal extends StatefulWidget {
  final BusinessCategory? selected;
  final ScrollController scrollController;

  const CategorySelectModal({
    super.key,
    this.selected = BusinessCategory.culinary,
    required this.scrollController,
  });

  @override
  State<CategorySelectModal> createState() => _CategorySelectModalState();
}

class _CategorySelectModalState extends State<CategorySelectModal> {
  BusinessCategory? current;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        current = widget.selected;
      });
    });
  }

  void confirm() {
    Navigator.of(context, rootNavigator: true).pop(current);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            controller: widget.scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                  child: Text(
                    'Select category',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                ...BusinessCategory.values.map(
                  (e) => RadioListTile(
                    title: Text(
                      e.text,
                    ),
                    value: e,
                    visualDensity: VisualDensity.compact,
                    groupValue: current,
                    onChanged: (value) {
                      setState(() {
                        current = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
          child: PrimaryButton(
            onPress: confirm,
            child: const Text('Confirm'),
          ),
        )
      ],
    );
  }
}
