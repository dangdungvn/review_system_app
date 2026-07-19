import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../index.dart';

part 'login_state.freezed.dart';

@freezed
sealed class LoginState extends BaseState with _$LoginState {
  const LoginState._();

  const factory LoginState({
    @Default('') String username,
    @Default('') String password,
    @Default(false) bool isPasswordVisible,
    @Default(false) bool rememberPassword,
  }) = _LoginState;
}
