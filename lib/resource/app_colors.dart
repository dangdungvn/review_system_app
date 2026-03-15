// ignore_for_file: avoid_hard_coded_colors
import 'package:flutter/material.dart';

import '../index.dart';

class AppColors {
  const AppColors({
    required this.black,
  });

  static late AppColors current;

  final Color black;

  static const defaultAppColor = AppColors(
    black: Colors.black,
  );

  static const darkThemeColor = defaultAppColor;

  static AppColors of(BuildContext context) {
    final appColor = Theme.of(context).appColor;

    current = appColor;

    return current;
  }
}
