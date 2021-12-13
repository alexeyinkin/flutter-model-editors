import 'package:flutter/material.dart';

import '../controllers/abstract_list.dart';
import 'default_delete_button.dart';

// TODO: Allow horizontal list
class ReorderableListViewEditor<
  T,
  C extends ValueNotifier<T?>
> extends StatelessWidget {
  final AbstractListEditingController<T, C> controller;
  final Widget Function(BuildContext context, C controller) itemBuilder;
  final Widget Function(BuildContext context, C controller)? deleteButtonBuilder;
  final bool shrinkWrap;
  final double spacing;

  /// A workaround for https://github.com/flutter/flutter/issues/88570
  /// and https://stackoverflow.com/q/70308654/11382675
  ///
  /// If you need to use providers with this list, add them both
  /// in the parent of the list and in this wrapper.
  ///
  /// This way, when this issue is fixed and the property is removed,
  /// it would mean one line removal for you.
  ///
  /// TODO: Remove when this is fixed.
  @Deprecated('A temporary workaround for Flutter issue 88570, will be removed when fixed.')
  final ValueWidgetBuilder<C> itemWrapper;

  ReorderableListViewEditor({
    Key? key,
    required this.controller,
    required this.itemBuilder,
    this.deleteButtonBuilder,
    this.shrinkWrap = false,
    this.spacing = .0,
    this.itemWrapper = _defaultItemWrapper,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) => _buildOnChange(context),
    );
  }

  Widget _buildOnChange(BuildContext context) {
    final children = <Widget>[];
    final paddings = _getPaddings();
    final length = controller.itemControllers.length;
    int index = 0;

    for (final itemController in controller.itemControllers) {
      children.add(
        itemWrapper(
          context,
          itemController,
          Container(
            key: ValueKey(itemController),
            padding: paddings[index],
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: itemBuilder(context, itemController),
                ),
                ..._getDeleteButtonIfNeed(context, itemController),
                if (length > 1) _getDragHandle(index),
              ],
            ),
          ),
        ),
      );
      index++;
    }

    return ReorderableListView(
      onReorder: controller.reorder,
      children: children,
      shrinkWrap: shrinkWrap,
      buildDefaultDragHandles: false,
      physics: shrinkWrap ? const NeverScrollableScrollPhysics() : null,
    );
  }

  List<EdgeInsets> _getPaddings() {
    final length = controller.itemControllers.length;
    if (length == 0) return [];

    final result = [
      EdgeInsets.only(top: 0, bottom: spacing / 2),
      ...List.filled(
        length - 1,
        EdgeInsets.only(top: spacing / 2, bottom: spacing / 2),
      ),
    ];

    result.last = EdgeInsets.only(top: result.last.top, bottom: 0);

    return result;
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

  Widget _getDragHandle(int index) {
    return ReorderableDragStartListener(
      index: index,
      child: MouseRegion(
        cursor: SystemMouseCursors.resizeUpDown,
        child: Container(
          width: 30,
          height: 30,
          child: const Icon(Icons.drag_handle),
        ),
      ),
    );
  }

  static Widget _defaultItemWrapper(BuildContext context, controller, Widget? child) => child ?? Container(key: ValueKey(controller));
}
