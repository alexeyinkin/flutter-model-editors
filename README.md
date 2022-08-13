This package provides controllers and editors for complex models and lists
and is inspired by simplicity of `TextEditingController`.
It encapsulates state management so you don't have to do a single `setState(){}`.

See the example on how to create an editor like this:

![Screenshot of a book editor](https://raw.githubusercontent.com/alexeyinkin/flutter-model-editors/main/example/book-editor.png)

This package provides the following controllers:

- `AbstractListEditingController` which is a `ValueNotifier` of `List<T?>`.
  It takes care for adding, deleting and reordering of list items.
  Just initialize it with a list of your models and then read the edited list.
- `CheckboxGroupEditingController` which is a `ValueNotifier` of `List<T>`.
  It takes care for storing multiple values according to the user checking
  and unchecking individual boxes.

This package provides the following widgets which use the mentioned controllers:

- `ColumnListEditor` which shows individual editors and allows to delete them.
- `ReorderableListViewEditor` which also allows reordering.
- `MaterialCheckboxColumn` which shows a checkbox group in a column.

A few widgets and controllers that are not mentioned here are experimental
and not recommended for use.

## Additional Information ##

The controllers in this package are pretty stable and are intended for public use.
The widgets on the other hand are mostly ad-hoc and are in development.
They lack many properties and customization.
If you wish to help, file an issue with your idea before contributing,
and I will see how to incorporate it.
