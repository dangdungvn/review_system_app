import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nalsflutter/index.dart';

import '../../../../common/index.dart';

class MockOnboardingViewModel extends StateNotifier<CommonState<OnboardingState>>
    with Mock
    implements OnboardingViewModel {
  MockOnboardingViewModel(super.state);
}

OnboardingViewModel _buildOnboardingViewModel([
  CommonState<OnboardingState>? state,
]) {
  return MockOnboardingViewModel(state ?? const CommonState(data: OnboardingState()));
}

void main() {
  group('others', () {
    testGoldens(
      'default state',
      (tester) async {
        await tester.testWidget(
          filename: 'onboarding_page/default state',
          widget: const OnboardingPage(),
          overrides: [
            onboardingViewModelProvider.overrideWith(
              (_) => _buildOnboardingViewModel(),
            ),
          ],
        );
      },
      skip: true,
    );
  });
}
