import 'package:flutter/widgets.dart';

import '../../model_editors.dart';

class ListAddButtonBuilder extends StatelessWidget {
  final AbstractListEditingController controller;
  final WidgetBuilder enabledBuilder;
  final WidgetBuilder? disabledBuilder;

  const ListAddButtonBuilder({
    Key? key,
    required this.controller,
    required this.enabledBuilder,
    this.disabledBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) => _buildOnChange(context),
    );
  }

  Widget _buildOnChange(BuildContext context) {
    if (controller.canAdd) return enabledBuilder(context);
    return disabledBuilder == null ? Container() : disabledBuilder!(context);
  }
}
