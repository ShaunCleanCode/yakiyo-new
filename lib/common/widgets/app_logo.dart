import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppLogo extends StatelessWidget {
  final double width;
  final double height;

  const AppLogo({this.width = 150, this.height = 150, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/images/appLogo.svg',
      width: width,
      height: height,
    );
  }
}
