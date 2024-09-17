import 'package:flutter/material.dart';

const _verticalPadding = 5.0;
const _horizontalPadding = 10.0;

const _padding = EdgeInsets.symmetric(
  horizontal: _horizontalPadding,
  vertical: _verticalPadding,
);

class CapsuleWidget extends StatelessWidget {
  final Widget child;
  final bool selected;

  const CapsuleWidget({
    required this.child,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: _getBackgroundColor(context),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Padding(
        padding: _padding,
        child: child,
      ),
    );
  }

  Color _getBackgroundColor(BuildContext context) {
    final themeData = Theme.of(context);

    // TODO(alexeyinkin): Use some theme colors.
    switch (themeData.brightness) {
      case Brightness.dark:
        return Color(selected ? 0x70FFFFFF : 0x40FFFFFF);
      case Brightness.light:
        return Color(selected ? 0x70000000 : 0x40000000);
    }
  }
}
