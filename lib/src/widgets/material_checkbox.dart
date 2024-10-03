import 'package:flutter/material.dart';

import 'controller_widget.dart';

class MaterialCheckbox extends StatelessWidget implements ControllerWidget {
  @override
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
