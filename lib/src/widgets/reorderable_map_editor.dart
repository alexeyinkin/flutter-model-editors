import 'package:flutter/foundation.dart';

import '../controllers/map.dart';
import 'reorderable_collection_editor.dart';

/// A widget to edit a map of [K] and [V].
///
/// [KC] is the type of the controller for each key.
/// [VC] is the type of the controller for each value.
typedef ReorderableMapEditor<
        K,
        V,
        KC extends ValueNotifier<K?>,
        VC extends ValueNotifier<V?>
//
        >
    = ReorderableCollectionEditor<
        Map<K, V?>,
        MapEntryController<K, V, KC, VC>,
        MapEditingController<K, V, KC, VC>
//
        >;
