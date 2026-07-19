import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../index.dart';

final loginViewModelProvider =
    StateNotifierProvider.autoDispose<LoginViewModel, CommonState<LoginState>>(
  (ref) => LoginViewModel(ref),
);

class LoginViewModel extends BaseViewModel<LoginState> {
  LoginViewModel(this.ref) : super(const CommonState(data: LoginState()));

  final Ref ref;

  void onUsernameChanged(String username) {
    data = data.copyWith(username: username);
  }

  void onPasswordChanged(String password) {
    data = data.copyWith(password: password);
  }

  void onTogglePasswordVisibility() {
    data = data.copyWith(isPasswordVisible: !data.isPasswordVisible);
  }

  void onToggleRememberPassword() {
    data = data.copyWith(rememberPassword: !data.rememberPassword);
  }

  bool get isFormValid => data.username.isNotEmpty && data.password.isNotEmpty;

  Future<void> onLoginPressed() async {
    if (!isFormValid) {
      return;
    }

    await runCatching(
      action: () async {
        await Future.delayed(const Duration(seconds: 1));

        unawaited(
          ref.nav.showDialog(
            CommonPopup.successDialog(
              title: 'Thành Công'.hardcoded,
              message: 'Tài khoản của bạn đã sẵn sàng, hãy đợi chút để vào trang chủ...'.hardcoded,
            ),
            barrierDismissible: false,
          ),
        );

        await Future.delayed(const Duration(seconds: 2));

        await ref.nav.replaceAll([const MainRoute()]);
      },
      handleLoading: true,
    );
  }

  void onRegisterPressed() {
    ref.nav.replace(const RegisterRoute());
  }
}
