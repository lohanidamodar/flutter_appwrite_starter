import 'package:flutter/material.dart';
import 'package:flutter_appwrite_starter/src/themes/assets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: SvgPicture.asset(AppAssets.logo),
      ),
    );
  }
}
