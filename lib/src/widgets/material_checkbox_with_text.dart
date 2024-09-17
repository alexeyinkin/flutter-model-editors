import 'package:flutter/material.dart';

import 'material_checkbox_with_text_with_value.dart';

class MaterialCheckboxWithText extends StatelessWidget {
  final ValueNotifier<bool> controller;
  final String text;

  const MaterialCheckboxWithText({
    required this.controller,
    required this.text,
  });

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: controller,
    builder: (context, _) {
      return MaterialCheckboxWithTextWithValue(
        onChanged: (newValue) => controller.value = newValue!,
        text: text,
        value: controller.value,
      );
    },
  );
}
