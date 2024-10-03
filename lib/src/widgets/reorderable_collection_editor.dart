import 'package:flutter/material.dart';

import '../controllers/collection.dart';
import 'controller_widget.dart';
import 'default_delete_button.dart';
import 'default_delete_this_and_after_button.dart';
import 'reorderable_list_editor.dart';
import 'reorderable_map_editor.dart';

// TODO(alexeyinkin): Allow horizontal list
/// A widget to edit a collection.
///
/// [T] is the type for data in collection.
/// [C] is the type for a controller for individual item.
/// [CC] is the type for the controller of the entire collection.
///
/// Use [ReorderableListEditor] and [ReorderableMapEditor] for convenience.
class ReorderableCollectionEditor<
    T,
    C extends ChangeNotifier,
    CC extends CollectionEditingController<T, C>
//
    > extends StatelessWidget implements ControllerWidget {
  @override
  final CC controller;
  final Widget Function(BuildContext context, C controller, int index)
      itemBuilder;
  final Widget Function(BuildContext context, C controller)?
      deleteButtonBuilder;
  final Widget Function(BuildContext context, C controller)?
      deleteThisAndAfterButtonBuilder;
  final bool showDeleteThisAndAfterButtons;
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
  // TODO(alexeyinkin): Remove when this is fixed.
  final ValueWidgetBuilder<C> itemWrapper;

  const ReorderableCollectionEditor({
    super.key,
    required this.controller,
    required this.itemBuilder,
    this.deleteButtonBuilder,
    this.deleteThisAndAfterButtonBuilder,
    this.showDeleteThisAndAfterButtons = false,
    this.shrinkWrap = false,
    this.spacing = .0,
    this.itemWrapper = _defaultItemWrapper,
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
                  child: itemBuilder(context, itemController, index),
                ),
                ..._getDeleteButtonIfNeed(context, itemController),
                ..._getDeleteAndFollowingButtonIfNeed(context, itemController),
                if (length > 1 && controller.isReorderable)
                  _getDragHandle(index),
              ],
            ),
          ),
        ),
      );
      index++;
    }

    return ReorderableListView(
      onReorder: controller.reorder,
      shrinkWrap: shrinkWrap,
      buildDefaultDragHandles: false,
      physics: shrinkWrap ? const NeverScrollableScrollPhysics() : null,
      children: children,
    );
  }

  List<EdgeInsets> _getPaddings() {
    final length = controller.itemControllers.length;
    if (length == 0) return [];

    final result = [
      EdgeInsets.only(bottom: spacing / 2),
      ...List.filled(
        length - 1,
        EdgeInsets.only(top: spacing / 2, bottom: spacing / 2),
      ),
    ];

    result.last = EdgeInsets.only(top: result.last.top);

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

  List<Widget> _getDeleteAndFollowingButtonIfNeed(
    BuildContext context,
    C itemController,
  ) {
    if (!showDeleteThisAndAfterButtons || !controller.canDelete) {
      return [];
    }

    if (deleteThisAndAfterButtonBuilder != null) {
      return [deleteButtonBuilder!(context, itemController)];
    }

    return [
      DefaultDeleteThisAndAfterButton(
        axis: Axis.vertical,
        onPressed: () =>
            controller.deleteItemControllerAndAfter(itemController),
      ),
    ];
  }

  Widget _getDragHandle(int index) {
    return ReorderableDragStartListener(
      index: index,
      child: const MouseRegion(
        cursor: SystemMouseCursors.resizeUpDown,
        child: SizedBox(
          width: 30,
          height: 30,
          child: Icon(Icons.drag_handle),
        ),
      ),
    );
  }

  static Widget _defaultItemWrapper(
    BuildContext context,
    controller,
    Widget? child,
  ) {
    return child ?? Container(key: ValueKey(controller));
  }
}
