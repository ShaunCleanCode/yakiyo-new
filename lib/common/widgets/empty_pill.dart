import 'package:flutter/material.dart';
import 'package:yakiyo/core/constants/assets_constants.dart';

class EmptyPill extends StatelessWidget {
  final double width;
  final double height;
  const EmptyPill({Key? key, this.width = 100, this.height = 100})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AssetsConstants.emptyPillPng,
      width: width,
      height: height,
      fit: BoxFit.contain,
    );
  }
}
