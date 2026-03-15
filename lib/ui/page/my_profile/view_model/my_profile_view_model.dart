import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../index.dart';

final myProfileViewModelProvider =
    StateNotifierProvider.autoDispose<MyProfileViewModel, CommonState<MyProfileState>>(
  (ref) => MyProfileViewModel(),
);

class MyProfileViewModel extends BaseViewModel<MyProfileState> {
  MyProfileViewModel() : super(const CommonState(data: MyProfileState()));
}
