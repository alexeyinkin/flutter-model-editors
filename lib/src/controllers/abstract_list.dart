import 'package:flutter/foundation.dart';

abstract class AbstractListEditingController<
  T,
  C extends ValueNotifier<T?>
> extends ValueNotifier<List<T?>> {
  final int? minLength;
  final int maxLength;
  var _itemControllers = <C>[];

  List<C> get itemControllers => _itemControllers;

  AbstractListEditingController({
    this.minLength,
    required this.maxLength,
  }) : super([]); // Do not use parent's _value.

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

  bool get canAdd => _itemControllers.length < maxLength;
  bool get canDelete => minLength == null || _itemControllers.length > minLength!;

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

  void reorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      // Removing the item at oldIndex will shorten the list by 1.
      newIndex -= 1;
    }

    final controller = _itemControllers.removeAt(oldIndex);
    _itemControllers.insert(newIndex, controller);
    notifyListeners();
  }

  @protected
  List<T?> sortValues(List<T?> values) {
    return values;
  }

  List<T> get nonNullItems {
    return value.whereType<T>().toList(growable: false);
  }

  C createItemController();

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
