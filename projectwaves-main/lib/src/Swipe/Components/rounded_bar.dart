import 'package:flutter/material.dart';

class RoundedBarIcon extends StatelessWidget {
  final double size;
  final Color color;

  const RoundedBarIcon({
    Key? key,
    required this.size,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size / 12,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(size / 10),
      ),
    );
  }
}
