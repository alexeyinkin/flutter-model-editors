import 'package:flutter/foundation.dart';

import '../controllers/list.dart';
import 'reorderable_collection_editor.dart';

/// A widget to edit a list of [T].
///
/// [C] is the type of the controller for each item.
typedef ReorderableListEditor<
        T,
        C extends ValueNotifier<T?>
//
        >
    = ReorderableCollectionEditor<
        List<T?>,
        C,
        ListEditingController<T, C>
//
        >;
