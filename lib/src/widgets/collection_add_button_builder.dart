import 'package:flutter/widgets.dart';

import '../controllers/collection.dart';
import 'default_add_button.dart';

class CollectionAddButtonBuilder extends StatelessWidget {
  final CollectionEditingController controller;
  final WidgetBuilder? enabledBuilder;
  final WidgetBuilder? disabledBuilder;
  final ValueGetter<bool>? isEnabled;

  const CollectionAddButtonBuilder({
    super.key,
    required this.controller,
    this.enabledBuilder,
    this.disabledBuilder,
    this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) => _buildOnChange(context),
    );
  }

  Widget _buildOnChange(BuildContext context) {
    if (isEnabled?.call() ?? controller.canAdd) {
      return enabledBuilder?.call(context) ??
          DefaultAddButton(onPressed: controller.addEmpty);
    }

    return disabledBuilder == null ? Container() : disabledBuilder!(context);
  }
}
