import 'package:flutter/material.dart';

class DecodedMessageField extends StatelessWidget {
  final List<String> decodedMessageParts;
  final List<int> brokenMessageIndexes;

  const DecodedMessageField({
    required this.decodedMessageParts,
    required this.brokenMessageIndexes,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: List<TextSpan>.generate(
          decodedMessageParts.length,
          (int index) => TextSpan(
            text: decodedMessageParts[index],
            style: TextStyle(
              color: brokenMessageIndexes.contains(index) ? Colors.red : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
