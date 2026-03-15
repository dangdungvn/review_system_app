import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../index.dart';

part 'login_state.freezed.dart';

@freezed
sealed class LoginState extends BaseState with _$LoginState {
  const LoginState._();

  const factory LoginState() = _LoginState;
}
