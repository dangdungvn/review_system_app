import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nalsflutter/index.dart';

import '../../../../common/index.dart';

class MockLoginViewModel extends StateNotifier<CommonState<LoginState>>
    with Mock
    implements LoginViewModel {
  MockLoginViewModel(super.state);
}

LoginViewModel _buildLoginViewModel([
  CommonState<LoginState>? state,
]) {
  return MockLoginViewModel(state ?? const CommonState(data: LoginState()));
}

void main() {
  group('design', () {
    testGoldens(
      'placeholder',
      (tester) async {
        await tester.testWidget(
          filename: 'login_page/placeholder',
          widget: const LoginPage(),
          overrides: [
            loginViewModelProvider.overrideWith(
              (_) => _buildLoginViewModel(),
            ),
          ],
        );
      },
      skip: true,
    );
  });

  group('others', () {
    testGoldens(
      'default state',
      (tester) async {
        await tester.testWidget(
          filename: 'login_page/default state',
          widget: const LoginPage(),
          overrides: [
            loginViewModelProvider.overrideWith(
              (_) => _buildLoginViewModel(),
            ),
          ],
        );
      },
      skip: true,
    );
  });
}
