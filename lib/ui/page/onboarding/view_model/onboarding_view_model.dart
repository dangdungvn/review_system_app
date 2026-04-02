import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../index.dart';

final onboardingViewModelProvider =
    StateNotifierProvider.autoDispose<OnboardingViewModel, CommonState<OnboardingState>>(
  (ref) => OnboardingViewModel(ref),
);

class OnboardingViewModel extends BaseViewModel<OnboardingState> {
  OnboardingViewModel(this.ref) : super(const CommonState(data: OnboardingState()));

  final Ref ref;

  void init() {}

  void onPageChanged(int page) {
    data = data.copyWith(currentPage: page);
  }

  Future<void> onRegisterPressed() async {
    await runCatching(
      action: () async {
        await ref.appPreferences.saveHasSeenOnboarding(hasSeenOnboarding: true);
        await ref.nav.replaceAll([const LoginRoute()]);
      },
      handleLoading: false,
    );
  }

  Future<void> onLoginPressed() async {
    await runCatching(
      action: () async {
        await ref.appPreferences.saveHasSeenOnboarding(hasSeenOnboarding: true);
        await ref.nav.replaceAll([const LoginRoute()]);
      },
      handleLoading: false,
    );
  }
}
