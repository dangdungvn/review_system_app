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
    required this.greyscale500,
    required this.greyscale300,
    required this.greyscale200,
    required this.greyscale50,
  });

  static late AppColors current;

  final Color black;
  final Color white;
  final Color primary;
  final Color primaryLight;
  final Color greyscale900;
  final Color greyscale700;
  final Color greyscale500;
  final Color greyscale300;
  final Color greyscale200;
  final Color greyscale50;

  static const defaultAppColor = AppColors(
    black: Colors.black,
    white: Colors.white,
    primary: Color(0xFF6A5AE0),
    primaryLight: Color(0xFFEDEFFF),
    greyscale900: Color(0xFF212121),
    greyscale700: Color(0xFF616161),
    greyscale500: Color(0xFF9E9E9E),
    greyscale300: Color(0xFFE0E0E0),
    greyscale200: Color(0xFFEEEEEE),
    greyscale50: Color(0xFFFAFAFA),
  );

  static const darkThemeColor = defaultAppColor;

  static AppColors of(BuildContext context) {
    final appColor = Theme.of(context).appColor;

    current = appColor;

    return current;
  }
}
