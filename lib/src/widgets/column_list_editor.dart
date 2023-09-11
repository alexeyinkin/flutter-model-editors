import 'package:flutter/widgets.dart';

import '../controllers/list.dart';
import 'default_delete_button.dart';

class ColumnListEditor<
    T,
    C extends ValueNotifier<T?>
//
    > extends StatelessWidget {
  final ListEditingController<T, C> controller;
  final Widget Function(BuildContext context, C controller) itemBuilder;
  final Widget Function(BuildContext context, C controller)?
      deleteButtonBuilder;
  final double spacing;

  const ColumnListEditor({
    super.key,
    required this.controller,
    required this.itemBuilder,
    this.deleteButtonBuilder,
    this.spacing = .0,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) => _buildOnChange(context),
    );
  }

  Widget _buildOnChange(BuildContext context) {
    final children = <Widget>[];

    for (final itemController in controller.itemControllers) {
      children.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: itemBuilder(context, itemController)),
            ..._getDeleteButtonIfNeed(context, itemController),
          ],
        ),
      );
      children.add(Container(height: spacing));
    }

    if (children.isNotEmpty) children.removeLast();

    return Column(
      children: children,
    );
  }

  List<Widget> _getDeleteButtonIfNeed(BuildContext context, C itemController) {
    if (!controller.canDelete) {
      return [];
    }

    if (deleteButtonBuilder != null) {
      return [deleteButtonBuilder!(context, itemController)];
    }

    return [
      DefaultDeleteButton(
        onPressed: () => controller.deleteItemController(itemController),
      ),
    ];
  }
}
