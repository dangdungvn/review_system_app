import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nalsflutter/index.dart';

import '../../../../common/index.dart';

class MockMyProfileViewModel extends StateNotifier<CommonState<MyProfileState>>
    with Mock
    implements MyProfileViewModel {
  MockMyProfileViewModel(super.state);
}

MyProfileViewModel _buildMyProfileViewModel([
  CommonState<MyProfileState>? state,
]) {
  return MockMyProfileViewModel(state ?? const CommonState(data: MyProfileState()));
}

void main() {
  group('design', () {
    testGoldens(
      'placeholder',
      (tester) async {
        await tester.testWidget(
          filename: 'my_profile_page/placeholder',
          widget: const MyProfilePage(),
          overrides: [
            myProfileViewModelProvider.overrideWith(
              (_) => _buildMyProfileViewModel(),
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
          filename: 'my_profile_page/default state',
          widget: const MyProfilePage(),
          overrides: [
            myProfileViewModelProvider.overrideWith(
              (_) => _buildMyProfileViewModel(),
            ),
          ],
        );
      },
      skip: true,
    );
  });
}
