import 'package:model_interfaces/model_interfaces.dart';

import 'with_text.dart';

class WithIdTitleEditingController<
    I,
    T extends WithIdTitle<I>
//
    > extends WithTextEditingController<T> {
  @override
  set value(T? value) {
    textEditingController.text = value?.title ?? '';
    super.value = value;
  }
}
