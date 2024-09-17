import 'package:flutter/material.dart';

class MaterialCheckbox extends StatelessWidget {
  final ValueNotifier<bool> controller;

  const MaterialCheckbox({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: controller,
    builder: (context, _) {
      return Checkbox(
        onChanged: (newValue) => controller.value = newValue!,
        value: controller.value,
      );
    },
  );
}
