import 'package:flutter/material.dart';

class NumericField extends StatelessWidget {
  final TextEditingController textController;
  final String fieldName;

  const NumericField({
    required this.textController,
    required this.fieldName,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(labelText: fieldName),
      controller: textController,
    );
  }
}
