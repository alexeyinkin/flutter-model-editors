import 'package:flutter/material.dart';

class DefaultDeleteButton extends StatelessWidget {
  final VoidCallback onPressed;

  const DefaultDeleteButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.delete),
      padding: const EdgeInsets.all(4),
      constraints: const BoxConstraints(),
      splashRadius: 20,
      onPressed: onPressed,
    );
  }
}
