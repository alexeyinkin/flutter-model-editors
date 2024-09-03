import 'dart:collection';

import 'package:flutter/material.dart';

import 'list.dart';
import 'map.dart';

/// A controller for managing a collection of other controllers.
///
/// Use it to create editors of lists that contain individual item editors.
/// It supports adding, deleting, and reordering items.
///
/// See [ListEditingController] and [MapEditingController].
abstract class CollectionEditingController<
    T,
    C extends ChangeNotifier
//
    > extends ValueNotifier<T> {
  /// Whether the map can be reordered.
  final bool isReorderable;

  /// The lower limit for the item count.
  final int minLength;

  /// The upper limit for the item count.
  final int maxLength;

  /// Whether to fire [notifyListeners] when item controllers fire their
  /// [notifyListeners].
  ///
  /// If `false`, only the actions on the list itself will fire.
  final bool notifyOnItemChanges;

  var _itemControllers = <C>[];

  CollectionEditingController(
    super._value, {
    required this.maxLength,
    this.isReorderable = true,
    this.minLength = 0,
    this.notifyOnItemChanges = true,
  })  : assert(minLength >= 0, 'minLength must be >= 0, $minLength given.'),
        assert(maxLength >= 1, 'maxLength must be >= 1, $maxLength given.');

  /// Returns the current list of controllers.
  List<C> get itemControllers => UnmodifiableListView(_itemControllers);

  @protected
  void replaceControllers(List<C> controllers) {
    _disposeControllers();
    _itemControllers = controllers;
  }

  /// Returns if items can be added to this controller.
  /// Uses [maxLength] that was set in the constructor for the upper limit.
  bool get canAdd => _itemControllers.length < maxLength;

  /// Returns if items can be deleted from this controller.
  /// Uses [minLength] that was set in the constructor for the lower limit.
  /// It also returns true for the empty list
  bool get canDelete => _itemControllers.length > minLength;

  /// Adds an empty item.
  C addEmpty();

  @protected
  void addController(C controller) {
    if (notifyOnItemChanges) {
      controller.addListener(notifyListeners);
    }

    _itemControllers.add(controller);
  }

  /// Deletes and disposes an item controller.
  /// It should be present in the list.
  void deleteItemController(C controller) {
    if (!canDelete) {
      throw Exception(
        'minLength is $minLength, '
        'tried to delete when only had ${_itemControllers.length}.',
      );
    }

    _itemControllers.removeWhere((aController) => aController == controller);
    controller.dispose();
    notifyListeners();
  }

  /// Deletes and disposes an item controller.
  /// It should be present in the list.
  void deleteItemControllerAndAfter(C controller) {
    if (!canDelete) {
      throw Exception(
        'minLength is $minLength, '
            'tried to delete when only had ${_itemControllers.length}.',
      );
    }

    final index = _itemControllers.indexWhere((c) => c == controller);
    if (index == -1) {
      throw Exception('Controller not found');
    }

    for (int i = index; i < _itemControllers.length; i++) {
      _itemControllers[i].dispose();
    }
    _itemControllers.removeRange(index, _itemControllers.length);
    notifyListeners();
  }

  /// Takes a controller at [oldIndex] and inserts it at [newIndex].
  ///
  /// This is designed for use with Flutter's built-in [ReorderableListView]
  /// widget. See its docs for help on indexes.
  void reorder(int oldIndex, int newIndex) {
    // Removing the item at oldIndex will shorten the list by 1.
    final fixedNewIndex = (oldIndex < newIndex) ? newIndex - 1 : newIndex;

    final controller = _itemControllers.removeAt(oldIndex);
    _itemControllers.insert(fixedNewIndex, controller);
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
