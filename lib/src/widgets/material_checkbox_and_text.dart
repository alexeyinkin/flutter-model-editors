import 'package:flutter/material.dart';

class MaterialCheckboxAndText extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final String text;

  MaterialCheckboxAndText({
    Key? key,
    required this.value,
    required this.onChanged,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: Change on the text tap too.
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
