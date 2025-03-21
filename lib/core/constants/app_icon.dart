import 'package:flutter/material.dart';
import 'package:test_interview/core/constants/app_color.dart';

const sizeDefault = 24.0;

class AppIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;

  const AppIcon({
    super.key,
    required this.icon,
    this.color = AppColor.white,
    this.size = sizeDefault,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      color: color,
      size: size,
    );
  }

  AppIcon copyWith({IconData? icon, Color? color, double? size}) {
    return AppIcon(
      icon: icon ?? this.icon,
      color: color ?? this.color,
      size: size ?? this.size,
    );
  }
}
