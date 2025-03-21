// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

class AppColor {
  AppColor._();
  static const primaryColor = Color(0xFF03ACF2);
  static const primaryLight = Color(0xFFB3F5FC);
  static const white = Color(0xFFFFFFFF);
  static const primaryDark = Color(0xFF919EAB);
  static const border = Color(0xFFCBD2D9);
  static const primaryMain = Color(0xFF03ACF2);
  static const textBlack = Color(0xFF47535D);
  static const textRed = Color(0xFFF32E22);
  static const shadowBar = Color(0x1418274B);
  static const orange = Color(0xFFFF9500);
  static const drawerBg = Color(0xFFFAFAFA);
  static const lightGrey = Color.fromARGB(22, 36, 34, 32);
  static const lightBlue = Color(0xFFD5E6FB);
  static const textBlue = Color(0xFF2F80ED);
  static const transparent = Colors.transparent;
  static const black = Color(0xFF242220);
  static const lightBlack = Color(0xCC242220);
  static const mainMenu = Color(0xFFB7E8FF);
  static const subMenu = Color(0xFFDCEDF9);
  static const foundation = Color(0xFF006EA9);
  static const disableButton = Color(0xFF66A8CB);
  static const tableSmall = Color(0xFFC8E7CA);
  static const lightGreen = Color(0xFF5FD372);
  static const successToast = Color(0xFF43d787);
  static const successTimeToast = Color(0xFFa1ebc3);
  static const errorToast = Color(0xFFf9461c);
  static const errorTimeToast = Color(0xFFfca28d);
  static const warningToast = Color(0xFFffbb00);
  static const warningTimeToast = Color(0xFFffdd80);
  static const redBoder = Color.fromRGBO(216, 66, 38, 1);
}

extension ColorOpacityToAlpha on Color {
  Color withAlphaFromOpacity(double opacity) {
    final int alpha = (opacity * 255).toInt().clamp(0, 255);
    return withAlpha(alpha);
  }
}
