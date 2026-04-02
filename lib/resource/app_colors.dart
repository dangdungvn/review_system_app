// ignore_for_file: avoid_hard_coded_colors
import 'package:flutter/material.dart';

import '../index.dart';

class AppColors {
  const AppColors({
    required this.black,
    required this.white,
    required this.primary,
    required this.primaryLight,
    required this.greyscale900,
    required this.greyscale700,
    required this.greyscale300,
  });

  static late AppColors current;

  final Color black;
  final Color white;
  final Color primary;
  final Color primaryLight;
  final Color greyscale900;
  final Color greyscale700;
  final Color greyscale300;

  static const defaultAppColor = AppColors(
    black: Colors.black,
    white: Colors.white,
    primary: Color(0xFF6A5AE0),
    primaryLight: Color(0xFFEDEFFF),
    greyscale900: Color(0xFF212121),
    greyscale700: Color(0xFF616161),
    greyscale300: Color(0xFFE0E0E0),
  );

  static const darkThemeColor = defaultAppColor;

  static AppColors of(BuildContext context) {
    final appColor = Theme.of(context).appColor;

    current = appColor;

    return current;
  }
}
