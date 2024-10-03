import 'package:flutter/material.dart';

import 'controller_widget.dart';

class EnumDropdownButton<T extends Enum> extends StatelessWidget
    implements ControllerWidget {
  @override
  final ValueNotifier<T?> controller;
  final Iterable<T> items;

  const EnumDropdownButton({
    super.key,
    required this.controller,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return DropdownButton<T>(
          items: items
              .map(
                (i) => DropdownMenuItem(
                  value: i,
                  child: Text(i.name),
                ),
              )
              .toList(growable: false),
          value: controller.value,
          onChanged: (v) => controller.value = v,
        );
      },
    );
  }
}
