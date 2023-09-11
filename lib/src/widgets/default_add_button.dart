import 'package:flutter/material.dart';

class DefaultAddButton extends StatelessWidget {
  final VoidCallback onPressed;

  const DefaultAddButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.add),
      padding: const EdgeInsets.all(4),
      constraints: const BoxConstraints(),
      splashRadius: 20,
      onPressed: onPressed,
    );
  }
}
