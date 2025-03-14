import 'package:flutter/material.dart';

class SubbandsCountTextField extends StatefulWidget {
  final TextEditingController textController;

  const SubbandsCountTextField({
    required this.textController,
    super.key,
  });

  @override
  _DropdownTextFieldExampleState createState() => _DropdownTextFieldExampleState();
}

class _DropdownTextFieldExampleState extends State<SubbandsCountTextField> {
  final List<String> _options = <String>['8', '16', '32', '64', '128'];

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.textController,
      decoration: InputDecoration(
        labelText: 'subbandCount',
        suffixIcon: PopupMenuButton<String>(
          icon: const Icon(Icons.arrow_drop_down),
          onSelected: (String value) {
            widget.textController.text = value;
          },
          itemBuilder: (BuildContext context) {
            return _options
                .map((String option) => PopupMenuItem<String>(
                      value: option,
                      child: Text(option),
                    ))
                .toList();
          },
        ),
      ),
    );
  }
}
