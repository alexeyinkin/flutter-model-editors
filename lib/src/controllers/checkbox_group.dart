import 'package:flutter/foundation.dart';

/// A controller for managing an unordered set of items.
/// They can be added or deleted.
class CheckboxGroupEditingController<T> extends ValueNotifier<List<T>> {
  final _values = <T, void>{};

  // Parent's _value is never used.
  CheckboxGroupEditingController() : super([]);

  /// The values that this controller currently holds.
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

  /// Adds [value] to this controller if it is not present yet.
  void select(T value) {
    if (_values.containsKey(value)) return;
    _values[value] = null;
    notifyListeners();
  }

  /// Removes [value] from this controller if it is present.
  void deselect(T value) {
    if (!_values.containsKey(value)) return;
    _values.remove(value);
    notifyListeners();
  }

  /// Adds or removes [value] based on [isSelected].
  // ignore: avoid_positional_boolean_parameters
  void setSelected(T value, bool isSelected) {
    if (isSelected) {
      select(value);
    } else {
      deselect(value);
    }
  }

  /// Checks if the value presents in this controller.
  bool isSelected(T value) => _values.containsKey(value);
}
