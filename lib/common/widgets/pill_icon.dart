import 'package:flutter/material.dart';

class PillIcon extends StatelessWidget {
  final double size;
  final PillColor color;
  final VoidCallback? onTap;

  const PillIcon({
    super.key,
    this.size = 40,
    this.color = PillColor.red,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(
        _getPillAssetPath(),
        width: size,
        height: size,
      ),
    );
  }

  String _getPillAssetPath() {
    switch (color) {
      case PillColor.red:
        return 'lib/common/assets/images/icons/redPill.png';
      case PillColor.yellow:
        return 'lib/common/assets/images/icons/yellowPill.png';
      case PillColor.green:
        return 'lib/common/assets/images/icons/greenPill.png';
    }
  }
}

enum PillColor {
  red,
  yellow,
  green,
}
