import 'package:flutter/material.dart';

import '../controllers/abstract_list.dart';
import 'default_delete_button.dart';

class WrapListEditor<T, C extends ValueNotifier<T?>> extends StatelessWidget {
  final AbstractListEditingController<T, C> controller;
  final Widget Function(BuildContext context, C controller) itemBuilder;
  final Widget Function(BuildContext context, C controller)?
      deleteButtonBuilder;
  final double spacing;
  final double runSpacing;
  final double deleteButtonSpacing;
  final WidgetBuilder? addButtonBuilder;

  const WrapListEditor({
    Key? key,
    required this.controller,
    required this.itemBuilder,
    this.deleteButtonBuilder,
    this.spacing = .0,
    this.runSpacing = .0,
    this.deleteButtonSpacing = .0,
    this.addButtonBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) => _buildWrapOnChange(context),
    );
  }

  Widget _buildWrapOnChange(BuildContext context) {
    final children = controller.itemControllers
        .map((c) => _buildItem(context, c))
        .toList(growable: false);

    if (controller.canAdd && addButtonBuilder != null) {
      children.add(addButtonBuilder!(context));
    }

    return Wrap(
      spacing: spacing,
      runSpacing: runSpacing,
      children: children,
    );
  }

  Widget _buildItem(BuildContext context, C itemController) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        itemBuilder(context, itemController),
        ..._getDeleteButtonIfNeed(context, itemController)
      ],
    );
  }

  List<Widget> _getDeleteButtonIfNeed(BuildContext context, C itemController) {
    if (!controller.canDelete) {
      return [];
    }

    final separator = Container(width: deleteButtonSpacing);

    if (deleteButtonBuilder != null) {
      return [separator, deleteButtonBuilder!(context, itemController)];
    }

    return [
      separator,
      DefaultDeleteButton(
        onPressed: () => controller.deleteItemController(itemController),
      ),
    ];
  }
}
