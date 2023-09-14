import 'package:flutter/material.dart';

class DefaultDeleteThisAndAfterButton extends StatelessWidget {
  final Axis axis;
  final VoidCallback onPressed;

  const DefaultDeleteThisAndAfterButton({
    super.key,
    required this.axis,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Stack(
        children: [
          const Icon(Icons.delete),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Text(
              _getArrow(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
      padding: const EdgeInsets.all(4),
      constraints: const BoxConstraints(),
      splashRadius: 20,
      onPressed: onPressed,
    );
  }

  String _getArrow() {
    switch (axis) {
      case Axis.vertical:
        return '↓';
      case Axis.horizontal:
        return '→';
    }
  }
}
