import 'package:flutter/foundation.dart';

/// A controller for managing a list of other controllers.
/// Use it to create editors of lists that contain individual item editors.
/// It supports adding, deleting, and reordering items.
abstract class AbstractListEditingController<
  T,
  C extends ValueNotifier<T?>
> extends ValueNotifier<List<T?>> {
  /// Sets the lower limit for item count.
  final int minLength;

  /// Sets the upper limit for item count.
  final int maxLength;

  var _itemControllers = <C>[];

  /// Returns the current list of controllers.
  /// It is only modifiable for performance reasons.
  /// Do not modify the returned list outside of this class.
  List<C> get itemControllers => _itemControllers;

  AbstractListEditingController({
    this.minLength = 0,
    required this.maxLength,
  }) :
      assert(minLength >= 0),
      assert(maxLength >= 1),
      super([]) // Do not use parent's _value.
  ;

  /// The list of current values that this controller holds.
  ///
  /// When you set its value, the controller for each value is created.
  /// It allows for less than [minLength] items so the user can enter some
  /// initial info.
  ///
  /// When you read its value, all controllers are surveyed for current values
  /// and the list of resulting values is returned.
  @override
  set value(List<T?>? values) {
    values = values ?? <T>[];

    if (values.length > maxLength) {
      throw Exception('maxLength is $maxLength, tried to set a list of ${values.length}.');
    }

    final controllers = <C>[];

    for (final value in values) {
      final controller = createItemController();
      controller.value = value;
      controllers.add(controller);
    }

    _disposeControllers();
    _itemControllers = controllers;

    notifyListeners();
  }

  /// Returns if items can be added to this controller.
  /// Uses [maxLength] that was set in the constructor for the upper limit.
  bool get canAdd => _itemControllers.length < maxLength;

  /// Returns if items can be deleted from this controller.
  /// Uses [minLength] that was set in the constructor for the lower limit.
  /// It also returns true for the empty list
  bool get canDelete => _itemControllers.length > minLength;

  /// Adds an item.
  ///
  /// Ignores [maxLength] because the button to add is supposed to
  /// not be visible if items are at their limit.
  /// Use [ListAddButtonBuilder] to automate such button visibility.
  void add(T? value) {
    final controller = createItemController();
    controller.value = value;
    _itemControllers.add(controller);

    notifyListeners();
  }

  @override
  List<T?> get value {
    final result = <T?>[];

    for (final controller in _itemControllers) {
      result.add(controller.value);
    }

    return sortValues(result);
  }

  /// Takes a controller at [oldIndex] and inserts it at [newIndex].
  ///
  /// This is designed for use with Flutter's built-in [ReorderableListView]
  /// widget. See its docs for help on indexes.
  void reorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      // Removing the item at oldIndex will shorten the list by 1.
      newIndex -= 1;
    }

    final controller = _itemControllers.removeAt(oldIndex);
    _itemControllers.insert(newIndex, controller);
    notifyListeners();
  }

  /// Override to get your values sorted when you read them
  /// from the controller.
  @protected
  List<T?> sortValues(List<T?> values) => values;

  /// Filters values for non-null after reading them from [value].
  List<T> get nonNullItems {
    return value.whereType<T>().toList(growable: false);
  }

  /// Override this to create item controllers when adding new items.
  C createItemController();

  /// Deletes and disposes an item controller.
  /// It should be present in the list.
  void deleteItemController(C controller) {
    if (!canDelete) {
      throw Exception('minLength is $minLength, tried to delete when only had ${_itemControllers.length}.');
    }

    _itemControllers.removeWhere((aController) => aController == controller);
    controller.dispose();
    notifyListeners();
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  void _disposeControllers() {
    for (final controller in _itemControllers) {
      controller.dispose();
    }
  }
}
