import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'assets.dart';

class Logo extends StatelessWidget {
  final double? height;
  const Logo({
    Key? key,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      Assets.logo,
      height: height,
      package: 'components',
    );
  }
}
