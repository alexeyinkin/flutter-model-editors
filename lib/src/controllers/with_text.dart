import 'package:flutter/widgets.dart';

abstract class WithTextEditingController<T> extends ValueNotifier<T?> {
  final textEditingController = TextEditingController();

  WithTextEditingController() : super(null);

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }
}
