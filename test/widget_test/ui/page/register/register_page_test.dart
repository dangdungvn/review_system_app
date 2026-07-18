import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nalsflutter/index.dart';

import '../../../../common/index.dart';

class MockRegisterViewModel extends StateNotifier<CommonState<RegisterState>>
    with Mock
    implements RegisterViewModel {
  MockRegisterViewModel(super.state);
}

RegisterViewModel _buildRegisterViewModel([
  CommonState<RegisterState>? state,
]) {
  return MockRegisterViewModel(
    state ?? const CommonState(data: RegisterState()),
  );
}

void main() {
  group(
    'others',
    () {
      testGoldens(
        'default state',
        (tester) async {
          await tester.testWidget(
            filename: 'register_page/default state',
            widget: const RegisterPage(),
            overrides: [
              registerViewModelProvider.overrideWith(
                (_) => _buildRegisterViewModel(),
              ),
            ],
          );
        },
        skip: true,
      );
    },
  );
}
