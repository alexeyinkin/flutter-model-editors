import 'package:flutter/foundation.dart';
import 'package:model_interfaces/model_interfaces.dart';

import '../widgets/model_view_or_edit.dart';

/// A controller to switch between viewing and editing of a model.
///
/// Used in [ModelViewOrEditWidget].
class EditorController<
    I,
    T extends WithId<I>,
    C extends ValueNotifier<T>
//
    > extends ChangeNotifier {
  /// The controller for the editing mode.
  final C editingController;

  /// The model to show for the viewing mode.
  T model;

  /// What to call to save the changes from [editingController].
  final AsyncValueSetter<T> saveCallback;

  bool _isEditing;
  bool _isSaving = false;

  EditorController({
    required this.editingController,
    required this.model,
    required this.saveCallback,
    bool isEditing = false,
  }) : _isEditing = isEditing;

  /// Saves the changes by calling [saveCallback] and updating
  /// the internal state.
  Future<void> save() async {
    _isSaving = true;
    notifyListeners();

    try {
      await saveCallback(editingController.value);
      // ignore: avoid_catches_without_on_clauses
    } catch (ex) {
      print(ex); // ignore: avoid_print
      rethrow;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  /// Whether currently in the editing mode.
  bool get isEditing => _isEditing;

  set isEditing(bool newValue) {
    _isEditing = newValue;
    notifyListeners();
  }

  /// Whether changes are currently being saved.
  bool get isSaving => _isSaving;
}
