import 'package:flutter/material.dart';

class BJIcon extends StatelessWidget {
  final String icon;
  final double size;
  const BJIcon({super.key, required this.icon, required this.size});

  @override
  Widget build(BuildContext context) {
    return Image.asset(icon, height: size);
  }
}
