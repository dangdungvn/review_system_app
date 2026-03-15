import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nalsflutter/index.dart';

import '../../../../common/index.dart';

class MockHomeViewModel extends StateNotifier<CommonState<HomeState>>
    with Mock
    implements HomeViewModel {
  MockHomeViewModel(super.state);
}

HomeViewModel _buildHomeViewModel([
  CommonState<HomeState>? state,
]) {
  return MockHomeViewModel(state ?? const CommonState(data: HomeState()));
}

void main() {
  group('design', () {
    testGoldens(
      'placeholder',
      (tester) async {
        await tester.testWidget(
          filename: 'home_page/placeholder',
          widget: const HomePage(),
          overrides: [
            homeViewModelProvider.overrideWith(
              (_) => _buildHomeViewModel(),
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
          filename: 'home_page/default state',
          widget: const HomePage(),
          overrides: [
            homeViewModelProvider.overrideWith(
              (_) => _buildHomeViewModel(),
            ),
          ],
        );
      },
      skip: true,
    );
  });
}
