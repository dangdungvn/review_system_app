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
        final authResponse = await ref.read(appApiServiceProvider).login(
              email: data.username,
              password: data.password,
            );

        if (authResponse != null) {
          final prefs = ref.read(appPreferencesProvider);
          if (authResponse.accessToken.isNotEmpty) {
            await prefs.saveAccessToken(authResponse.accessToken);
          }
          if (authResponse.refreshToken.isNotEmpty) {
            await prefs.saveRefreshToken(authResponse.refreshToken);
          }
          final savedAccessToken = await prefs.accessToken;
          final savedRefreshToken = await prefs.refreshToken;
          print('🔑 [LOGIN SUCCESS] Saved Access Token: $savedAccessToken'.hardcoded);
          print('🔑 [LOGIN SUCCESS] Saved Refresh Token: $savedRefreshToken'.hardcoded);
          await prefs.saveIsLoggedIn(true);
          await prefs.saveUserId(authResponse.user.id);
          await prefs.saveEmail(authResponse.user.email);
          if (authResponse.user.avatarUrl != null) {
            await prefs.saveAvatarUrl(authResponse.user.avatarUrl!);
          }

          unawaited(
            ref.nav.showDialog(
              CommonPopup.successDialog(
                title: 'Thành Công'.hardcoded,
                message: 'Đăng nhập thành công, chuẩn bị chuyển hướng...'.hardcoded,
              ),
              barrierDismissible: false,
            ),
          );

          await Future.delayed(const Duration(milliseconds: 1500));

          await ref.nav.replaceAll([const MainRoute()]);
        }
      },
      handleLoading: true,
    );
  }

  void onRegisterPressed() {
    ref.nav.replace(const RegisterRoute());
  }
}
