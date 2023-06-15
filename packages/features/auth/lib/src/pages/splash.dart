import 'package:flutter/material.dart';
import 'package:components/components.dart';

class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Material(
      child: Center(
        child: Logo(basePath: 'packages/components',),
      ),
    );
  }
}
