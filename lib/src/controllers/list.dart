import 'package:flutter/material.dart';

import '../widgets/collection_add_button_builder.dart';
import 'collection.dart';

/// A controller for managing a list of other controllers.
///
/// Use it to create editors of lists that contain individual item editors.
/// It supports adding, deleting, and reordering items.
class ListEditingController<
    T,
    C extends ValueNotifier<T?>
//
    > extends CollectionEditingController<List<T?>, C> {
  final ValueGetter<C> createItemController;

  ListEditingController({
    required this.createItemController,
    required super.maxLength,
    super.minLength,
    super.notifyOnItemChanges,
  }) : super([]);

  /// The list of current values that this controller holds.
  ///
  /// When you set its value, the controller for each value is created.
  /// It allows for less than [minLength] items so the user can enter some
  /// initial info.
  ///
  /// When you read its value, all controllers are surveyed for current values
  /// and the list of resulting values is returned.
  @override
  set value(List<T?> values) {
    if (values.length > maxLength) {
      throw Exception(
        'maxLength is $maxLength, got a list of ${values.length}.',
      );
    }

    final controllers = <C>[];

    for (final value in values) {
      final controller = createItemController();
      controller.value = value;

      if (notifyOnItemChanges) {
        controller.addListener(notifyListeners);
      }

      controllers.add(controller);
    }

    replaceControllers(controllers);
    notifyListeners();
  }

  @override
  C addEmpty() => add(null);

  /// Adds an item.
  ///
  /// Ignores [maxLength] because the button to add is supposed to
  /// not be visible if items are at their limit.
  /// Use [CollectionAddButtonBuilder] to automate such button visibility.
  C add(T? value) {
    final controller = createItemController();
    controller.value = value;

    addController(controller);
    notifyListeners();
    return controller;
  }

  @override
  List<T?> get value {
    final result = <T?>[];

    for (final controller in itemControllers) {
      result.add(controller.value);
    }

    return result;
  }

  /// Filters values for non-null after reading them from [value].
  List<T> get nonNullValues {
    return value.whereType<T>().toList(growable: false);
  }
}
