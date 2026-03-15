import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../index.dart';

final loginViewModelProvider =
    StateNotifierProvider.autoDispose<LoginViewModel, CommonState<LoginState>>(
  (ref) => LoginViewModel(),
);

class LoginViewModel extends BaseViewModel<LoginState> {
  LoginViewModel() : super(const CommonState(data: LoginState()));
}
