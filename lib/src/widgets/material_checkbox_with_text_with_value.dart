import 'package:flutter/material.dart';

class MaterialCheckboxWithTextWithValue extends StatelessWidget {
  final ValueChanged<bool?> onChanged;
  final String text;
  final bool value;

  const MaterialCheckboxWithTextWithValue({
    super.key,
    required this.onChanged,
    required this.text,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    // TODO(alexeyinkin): Change on the text tap too.
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          onChanged: onChanged,
          value: value,
        ),
        Container(width: 10),
        Text(text),
      ],
    );
  }
}
