import 'package:flutter/material.dart';
import 'package:model_interfaces/model_interfaces.dart';

import '../controllers/checkbox_group.dart';
import 'controller_widget.dart';
import 'material_checkbox_with_text_with_value.dart';

class MaterialCheckboxColumn<T> extends StatelessWidget
    implements ControllerWidget {
  @override
  final CheckboxGroupEditingController<T> controller;
  final List<T> allValues;
  final Map<T, String>? labels;

  const MaterialCheckboxColumn({
    super.key,
    required this.controller,
    required this.allValues,
    this.labels,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, value, child) => _buildOnChange(),
    );
  }

  Widget _buildOnChange() {
    final children = <Widget>[];

    for (final value in allValues) {
      children.add(
        MaterialCheckboxWithTextWithValue(
          value: controller.isSelected(value),
          onChanged: (isSelected) =>
              controller.setSelected(value, isSelected ?? false),
          text: _getTitle(value),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  String _getTitle(T value) {
    final label = labels?[value];
    if (label != null) return label;

    if (value is WithTitle) return value.title;

    return value.toString();
  }
}
