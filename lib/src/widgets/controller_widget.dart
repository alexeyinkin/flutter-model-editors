import 'package:flutter/foundation.dart';

/// An interface for widgets that have a controller.
abstract class ControllerWidget {
  ChangeNotifier get controller;
}
