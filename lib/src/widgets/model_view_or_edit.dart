import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:model_interfaces/model_interfaces.dart';

import '../controllers/editor.dart';
import 'model_view_or_edit_raw.dart';

class ModelViewOrEditWidget<
    I,
    T extends WithId<I>,
    C extends ValueNotifier<T>
//
    > extends StatefulWidget {
  final ValueGetter<C> createController;
  final T model;
  final AsyncValueSetter<T> saveCallback;

  final ModelViewBuilder<T> viewBuilder;
  final ModelEditBuilder<T, C> editBuilder;
  final Widget Function(BuildContext, Widget)? buttonRowBuilder;

  const ModelViewOrEditWidget({
    super.key,
    required this.createController,
    required this.editBuilder,
    required this.model,
    required this.saveCallback,
    required this.viewBuilder,
    this.buttonRowBuilder,
  });

  @override
  State<ModelViewOrEditWidget<I, T, C>> createState() =>
      _ModelViewOrEditWidgetState<I, T, C>();
}

class _ModelViewOrEditWidgetState<
    I,
    T extends WithId<I>,
    C extends ValueNotifier<T>
//
    > extends State<ModelViewOrEditWidget<I, T, C>> {
  late final EditorController<I, T, C> _controller = EditorController(
    editingController: widget.createController(),
    model: widget.model,
    saveCallback: widget.saveCallback,
  );

  @override
  Widget build(BuildContext context) {
    return ModelViewOrEditRawWidget(
      buttonRowBuilder: widget.buttonRowBuilder,
      controller: _controller,
      editBuilder: widget.editBuilder,
      editCallback: () => _controller.editingController.value = widget.model,
      model: widget.model,
      viewBuilder: widget.viewBuilder,
    );
  }
}
