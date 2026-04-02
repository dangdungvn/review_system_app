import 'package:flutter/material.dart';

import '../../../../index.dart';

class OnboardingPageIndicator extends StatelessWidget {
  const OnboardingPageIndicator({
    required this.pageController,
    required this.pageCount,
    super.key,
  });

  final PageController pageController;
  final int pageCount;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pageController,
      builder: (context, _) {
        final page = pageController.hasClients && pageController.page != null
            ? pageController.page!
            : pageController.initialPage.toDouble();

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            pageCount,
            (index) {
              final progress = (1 - (page - index).abs()).clamp(0.0, 1.0);
              final dotWidth = 8 + 24 * progress;

              return Padding(
                padding: EdgeInsets.only(right: index < pageCount - 1 ? 5 : 0),
                child: Container(
                  width: dotWidth,
                  height: 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    gradient: progress > 0
                        ? LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color.lerp(color.greyscale300, color.primary, progress)!,
                              Color.lerp(
                                color.greyscale300,
                                color.primary.withValues(alpha: 0.7),
                                progress,
                              )!,
                            ],
                          )
                        : null,
                    color: progress == 0 ? color.greyscale300 : null,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
