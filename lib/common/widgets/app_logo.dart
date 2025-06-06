import 'package:flutter/material.dart';

import 'package:yakiyo/core/constants/assets_constants.dart';

class AppLogo extends StatelessWidget {
  final double width;
  final double height;

  const AppLogo({this.width = 150, this.height = 150, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AssetsConstants.appLogoPng,
      width: width,
      height: height,
      fit: BoxFit.contain,
    );
  }
}
