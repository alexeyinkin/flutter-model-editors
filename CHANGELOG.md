## 0.3.0

* **BREAKING**: Renamed `AbstractListEditingController` to `ListEditingController`,
  changed its abstract `createController` method to a property.
* **BREAKING**: Deleted `ListEditingController.sortValues`. Add some kind of `sortedValue` if needed.
* **BREAKING**: `ReorderableListViewEditor` renamed to `ReorderableCollectionEditor`.
* **BREAKING**: `ListAddButtonBuilder` renamed to `CollectionAddButtonBuilder`.
* **BREAKING**: Require Dart 2.17 & Flutter 3.0.
* Added the abstract `CollectionEditingController`.
* Added `MapEditingController`, `ReorderableMapEditor`.
* Added `CollectionEditingController.isReorderable`, defaults to `true`.
* Added `ModelViewOrEditWidget`, `ModelViewOrEditRawWidget`.
* Added `EnumDropdownButton`.
* Added `DefaultAddButton`.
* `CollectionAddButtonBuilder.enabledBuilder` is optional and defaults to `DefaultAddButton`.

## 0.2.0

* **BREAKING**: `AbstractListEditingController` requires non-null `value`.
* Re-licensed under MIT No Contribution.
* Uses `total_lints`.

## 0.1.6

* Add `ReorderableListViewEditor.itemWrapper` as a workaround for https://github.com/flutter/flutter/issues/88570.

## 0.1.5

* Add `WrapListEditor` widget.

## 0.1.4

* Add `AbstractListEditingController.notifyOnItemChanges`.
* In `AbstractListEditingController`, fire `notifyChanges()` on item changes by default.

## 0.1.3

In `ReorderableListViewEditor`:
* Use `NeverScrollableScrollPhysics` if `shrinkWrap == true`.
* Change mouse cursor over drag handles.
* Hide drag handle for less than two items.

## 0.1.2

* **BREAKING**: Renamed `AbstractListEditingController.nonNullItems` to `nonNullValues`.

## 0.1.1

* Added code docs.
* **BREAKING**: `AbstractListEditingController.minLength` is non-null.

## 0.1.0

* Initial release.
