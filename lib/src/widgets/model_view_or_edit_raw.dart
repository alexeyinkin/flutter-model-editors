import 'package:flutter/material.dart';
import 'package:model_interfaces/model_interfaces.dart';

import '../controllers/editor.dart';

typedef ModelViewBuilder<T> = Widget Function(
  BuildContext,
  T,
  Widget buttons,
);

typedef ModelEditBuilder<T, C> = Widget Function(
  BuildContext,
  T,
  C controller,
  Widget buttons,
);

class ModelViewOrEditRawWidget<
    I,
    T extends WithId<I>,
    C extends ValueNotifier<T>
//
    > extends StatelessWidget {
  final EditorController<I, T, C> controller;
  final T model;
  final VoidCallback? editCallback;

  final ModelViewBuilder<T> viewBuilder;
  final ModelEditBuilder<T, C> editBuilder;
  final Widget Function(BuildContext, Widget)? buttonRowBuilder;

  const ModelViewOrEditRawWidget({
    super.key,
    required this.controller,
    required this.editBuilder,
    required this.model,
    required this.viewBuilder,
    this.buttonRowBuilder,
    this.editCallback,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final buttons = _getButtonRow(context);

        if (!controller.isEditing) {
          return viewBuilder(
            context,
            model,
            buttons,
          );
        }

        return editBuilder(
          context,
          model,
          controller.editingController,
          buttons,
        );
      },
    );
  }

  Widget _getButtonRow(BuildContext context) {
    final row = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (controller.isEditing) ...[
          IconButton(
            onPressed: controller.isSaving
                ? null
                : () {
                    // Reset changes.
                    controller.editingController.value = model;
                    controller.isEditing = false;
                  },
            icon: const Icon(Icons.cancel),
          ),
          const SizedBox(width: 20),
          IconButton(
            onPressed: controller.isSaving
                ? null
                : () async {
                    await controller.save();
                    controller.isEditing = false;
                  },
            icon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.save),
                if (controller.isSaving) ...[
                  const SizedBox(width: 10),
                  const CircularProgressIndicator(),
                ],
              ],
            ),
          ),
        ],
        if (!controller.isEditing)
          IconButton(
            onPressed: () {
              editCallback?.call();
              controller.isEditing = true;
            },
            icon: const Icon(Icons.edit),
          ),
      ],
    );

    return buttonRowBuilder?.call(context, row) ?? row;
  }
}
