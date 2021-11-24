import 'package:flutter/foundation.dart';

class CheckboxGroupEditingController<T> extends ValueNotifier<List<T>> {
  final _values = <T, void>{};

  // Parent's _value is never used.
  CheckboxGroupEditingController() : super([]);

  @override
  List<T> get value {
    return _values.keys.toList(growable: false);
  }

  @override
  set value(List<T> values) {
    _values.clear();

    for (final value in values) {
      _values[value] = null;
    }

    notifyListeners();
  }

  void select(T value) {
    if (_values.containsKey(value)) return;
    _values[value] = null;
    notifyListeners();
  }

  void deselect(T value) {
    if (!_values.containsKey(value)) return;
    _values.remove(value);
    notifyListeners();
  }

  void setSelected(T value, bool isSelected) {
    if (isSelected) {
      select(value);
    } else {
      deselect(value);
    }
  }

  bool isSelected(T value) => _values.containsKey(value);
}
