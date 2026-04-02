import 'package:flutter/material.dart';

import '../../../../index.dart';

class OnboardingContent extends StatelessWidget {
  const OnboardingContent({
    required this.imagePath,
    required this.title,
    required this.description,
    super.key,
  });

  final String imagePath;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: CommonImage.asset(
            path: imagePath,
            width: 309,
            height: 250,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              CommonText(
                title,
                textAlign: TextAlign.center,
                style: style(
                  color: color.greyscale900,
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 20),
              CommonText(
                description,
                textAlign: TextAlign.center,
                style: style(
                  color: color.greyscale700,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  height: 1.4,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
