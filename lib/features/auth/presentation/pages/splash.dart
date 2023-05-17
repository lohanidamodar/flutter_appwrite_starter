import 'package:flutter/material.dart';
import 'package:flutter_appwrite_starter/core/res/assets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: SvgPicture.asset(AppAssets.logo),
      ),
    );
  }
}
