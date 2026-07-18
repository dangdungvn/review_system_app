import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../index.dart';

part 'register_state.freezed.dart';

@freezed
sealed class RegisterState extends BaseState with _$RegisterState {
  const RegisterState._();

  const factory RegisterState({
    @Default('') String name,
    @Default('') String password,
    @Default('') String confirmPassword,
    @Default('') String phoneNumber,
    @Default('') String email,
    @Default('') String countryFlag,
    @Default('') String countryCode,
    @Default(false) bool isPasswordVisible,
    @Default(false) bool isConfirmPasswordVisible,
  }) = _RegisterState;
}
