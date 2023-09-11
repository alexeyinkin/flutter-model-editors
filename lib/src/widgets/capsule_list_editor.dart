import 'package:flutter/material.dart';

import '../controllers/list.dart';
import 'capsule.dart';

class CapsuleListEditor<
    T,
    C extends ValueNotifier<T?>
//
    > extends StatelessWidget {
  final ListEditingController<T, C> controller;
  final Widget Function(BuildContext context, T value) capsuleContentBuilder;
  final WidgetBuilder? addButtonBuilder;

  const CapsuleListEditor({
    required this.controller,
    required this.capsuleContentBuilder,
    this.addButtonBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, value, child) => _buildWrapOnChange(context),
    );
  }

  Widget _buildWrapOnChange(BuildContext context) {
    final children = controller.itemControllers
        .map((c) => _buildCapsule(context, c))
        .toList();

    if (controller.canAdd && addButtonBuilder != null) {
      children.add(addButtonBuilder!(context));
    }

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: children,
    );
  }

  Widget _buildCapsule(BuildContext context, C oneController) {
    return CapsuleWidget(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildCapsuleContent(context, oneController),
          Container(width: 10),
          GestureDetector(
            child: const Icon(Icons.cancel),
            onTap: () => controller.deleteItemController(oneController),
          ),
        ],
      ),
    );
  }

  Widget _buildCapsuleContent(BuildContext context, C oneController) {
    final obj = oneController.value;
    return (obj == null) ? Container() : capsuleContentBuilder(context, obj);
  }
}
