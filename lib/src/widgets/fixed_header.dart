import 'package:flutter/widgets.dart';

/// A fixed [header] and [child] below it in a `SingleChildScrollView`.
class FixedHeaderWidget extends StatelessWidget {
  final Widget child;
  final Widget header;

  const FixedHeaderWidget({
    super.key,
    required this.child,
    required this.header,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        header,
        Expanded(
          child: SingleChildScrollView(
            child: child,
          ),
        ),
      ],
    );
  }
}
