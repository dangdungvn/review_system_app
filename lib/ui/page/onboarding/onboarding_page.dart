import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../index.dart';

@RoutePage()
class OnboardingPage extends BasePage<OnboardingState,
    AutoDisposeStateNotifierProvider<OnboardingViewModel, CommonState<OnboardingState>>> {
  const OnboardingPage({super.key});

  @override
  ScreenViewEvent get screenViewEvent => ScreenViewEvent(screenName: ScreenName.onboardingPage);

  @override
  AutoDisposeStateNotifierProvider<OnboardingViewModel, CommonState<OnboardingState>>
      get provider => onboardingViewModelProvider;

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    final pageController = usePageController();

    useEffect(
      () {
        Future.microtask(() {
          ref.read(provider.notifier).init();
        });

        return null;
      },
      [],
    );

    return CommonScaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: pageController,
                onPageChanged: (page) => ref.read(provider.notifier).onPageChanged(page),
                children: [
                  OnboardingContent(
                    imagePath: Assets.images.onboarding1,
                    title: l10n.onboardingTitle1,
                    description: l10n.onboardingDescription1,
                  ),
                  OnboardingContent(
                    imagePath: Assets.images.onboarding2,
                    title: l10n.onboardingTitle2,
                    description: l10n.onboardingDescription2,
                  ),
                  OnboardingContent(
                    imagePath: Assets.images.onboarding3,
                    title: l10n.onboardingTitle3,
                    description: l10n.onboardingDescription3,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  OnboardingPageIndicator(
                    pageController: pageController,
                    pageCount: 3,
                  ),
                  const SizedBox(height: 40),
                  OnboardingPrimaryButton(
                    text: l10n.onboardingRegister,
                    onPressed: () => ref.read(provider.notifier).onRegisterPressed(),
                  ),
                  const SizedBox(height: 12),
                  OnboardingSecondaryButton(
                    text: l10n.onboardingLogin,
                    onPressed: () => ref.read(provider.notifier).onLoginPressed(),
                  ),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
