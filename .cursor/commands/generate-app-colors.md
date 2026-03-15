# Generate App Colors

## Purpose
Fetch all colors from Figma and add to class AppColors

## Parameters:
- `figma_link`: The Figma link to fetch colors from

## Steps

Use tools of Figma MCP to fetch all colors from the {{figma_link}} to class AppColors [app_colors.dart](lib/resource/app_colors.dart), without comment, do not modify any existing colors.

## Example
```dart
// ignore_for_file: avoid_hard_coded_colors
import 'package:flutter/material.dart';

import '../index.dart';

class AppColors {
  const AppColors({
    required this.neutralDark10,
    required this.neutralDark40,
    required this.greenBackground,
    required this.primary10,
    required this.primary20,
    required this.primary30,
    required this.primary40,
    required this.primary50,
  });

  static late AppColors current;

  final Color neutralDark10;
  final Color neutralDark40;
  final Color greenBackground;
  final Color primary10;
  final Color primary20;
  final Color primary30;
  final Color primary40;
  final Color primary50;

  static const defaultAppColor = AppColors(
    neutralDark10: Color(0xFF1E1E1E),
    neutralDark40: Color(0xFF71727A),
    greenBackground: Color(0xFFF5FCF8),
    primary10: Color(0xFF40904B),
    primary20: Color(0xFF2E6C38),
    primary30: Color(0xFF6CB682),
    primary40: Color(0xFFA8D5B7),
    primary50: Color(0xFFD3E7DC),
  );

  static const darkThemeColor = defaultAppColor;

  static AppColors of(BuildContext context) {
    final appColor = Theme.of(context).appColor;

    current = appColor;

    return current;
  }
}
```