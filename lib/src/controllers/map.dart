import 'package:flutter/material.dart';

import '../widgets/collection_add_button_builder.dart';
import 'collection.dart';

/// A controller for managing a map of other controllers.
///
/// Use it to create editors of maps that contain individual key and value
/// editors. It supports adding, deleting, and reordering items.
class MapEditingController<
        K,
        V,
        KC extends ValueNotifier<K?>,
        VC extends ValueNotifier<V?>
//
        >
    extends CollectionEditingController<Map<K, V?>,
        MapEntryController<K, V, KC, VC>> {
  final ValueGetter<KC> createKeyController;

  final ValueGetter<VC> createValueController;

  MapEditingController({
    required this.createKeyController,
    required this.createValueController,
    required super.maxLength,
    super.isReorderable,
    super.minLength,
    super.notifyOnItemChanges,
  }) : super({});

  /// The list of current values that this controller holds.
  ///
  /// When you set its value, the controller for each value is created.
  /// It allows for less than [minLength] items so the user can enter some
  /// initial info.
  ///
  /// When you read its value, all controllers are surveyed for current values
  /// and the list of resulting values is returned.
  @override
  set value(Map<K, V?> values) {
    if (values.length > maxLength) {
      throw Exception(
        'maxLength is $maxLength, got a list of ${values.length}.',
      );
    }

    final controllers = <MapEntryController<K, V, KC, VC>>[];

    for (final entry in values.entries) {
      controllers.add(_createController(entry.key, entry.value));
    }

    replaceControllers(controllers);
    notifyListeners();
  }

  @override
  void addEmpty() => add(null, null);

  /// Adds an item.
  ///
  /// Ignores [maxLength] because the button to add is supposed to
  /// not be visible if items are at their limit.
  /// Use [CollectionAddButtonBuilder] to automate such button visibility.
  void add(K? key, V? value) {
    addController(_createController(key, value));
    notifyListeners();
  }

  MapEntryController<K, V, KC, VC> _createController(K? key, V? value) {
    final keyController = createKeyController();
    final valueController = createValueController();

    keyController.value = key;
    valueController.value = value;

    if (notifyOnItemChanges) {
      keyController.addListener(notifyListeners);
      valueController.addListener(notifyListeners);
    }

    return MapEntryController(keyController, valueController);
  }

  @override
  Map<K, V?> get value {
    final result = <K, V?>{};

    for (final pair in itemControllers) {
      final key = pair.keyController.value;

      if (key == null) {
        continue;
      }

      result[key] = pair.valueController.value;
    }

    return result;
  }

  /// Filters values for non-null after reading them from [value].
  Map<K, V> get nonNullValues {
    return {
      for (final entry in value.entries)
        if (entry.value != null) entry.key: entry.value as V,
    };
  }
}

/// A controller for each entry in [MapEditingController].
class MapEntryController<
    K,
    V,
    KC extends ValueNotifier<K?>,
    VC extends ValueNotifier<V?>
//
    > extends ChangeNotifier {
  final KC keyController;
  final VC valueController;

  MapEntryController(this.keyController, this.valueController) {
    keyController.addListener(notifyListeners);
    valueController.addListener(notifyListeners);
  }

  @override
  void dispose() {
    valueController.removeListener(notifyListeners);
    keyController.removeListener(notifyListeners);
    super.dispose();
  }
}
