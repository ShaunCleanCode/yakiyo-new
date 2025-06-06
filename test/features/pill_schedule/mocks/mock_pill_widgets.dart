import 'package:flutter/material.dart';
import 'package:yakiyo/common/widgets/pill_card.dart';
import 'package:yakiyo/common/widgets/pill_icon.dart';

class MockPillCard extends StatelessWidget {
  final String name;
  final List<String> timeSlots;
  final PillColor pillColor;
  final VoidCallback? onTap;

  const MockPillCard({
    super.key,
    required this.name,
    required this.timeSlots,
    this.pillColor = PillColor.red,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(name),
            Text(timeSlots.join(', ')),
          ],
        ),
      ),
    );
  }
}

class MockPillIcon extends StatelessWidget {
  final double size;
  final PillColor color;
  final VoidCallback? onTap;

  const MockPillIcon({
    super.key,
    this.size = 40,
    this.color = PillColor.red,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        color: _getColor(),
      ),
    );
  }

  Color _getColor() {
    switch (color) {
      case PillColor.red:
        return Colors.red;
      case PillColor.yellow:
        return Colors.yellow;
      case PillColor.green:
        return Colors.green;
    }
  }
}
