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
