import 'package:flutter/material.dart';

class EnumDropdownButton<T extends Enum> extends StatelessWidget {
  final Iterable<T> items;
  final ValueNotifier<T?> controller;

  const EnumDropdownButton({
    super.key,
    required this.controller,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
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
  }
}
