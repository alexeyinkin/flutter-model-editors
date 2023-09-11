import 'package:flutter/material.dart';

class MaterialCheckboxAndText extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final String text;

  const MaterialCheckboxAndText({
    super.key,
    required this.value,
    required this.onChanged,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    // TODO(alexeyinkin): Change on the text tap too.
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
        ),
        Container(width: 10),
        Text(text),
      ],
    );
  }
}
