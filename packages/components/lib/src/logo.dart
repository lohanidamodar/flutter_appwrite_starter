import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'assets.dart';

class Logo extends StatelessWidget {
  final double? height;
  final String basePath;
  const Logo({Key? key, this.height, this.basePath = ''}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      '$basePath${Assets.logo}',
      height: height,
    );
  }
}
