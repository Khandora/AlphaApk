import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final Color color;

  const LoadingIndicator(this.color);

  @override
  Widget build(BuildContext context) => Center(
          child: Padding(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
        padding: const EdgeInsets.all(16.0),
      ));
}
