import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../index.dart';

final registerViewModelProvider =
    StateNotifierProvider.autoDispose<RegisterViewModel, CommonState<RegisterState>>(
  (ref) => RegisterViewModel(ref),
);

class RegisterViewModel extends BaseViewModel<RegisterState> {
  RegisterViewModel(this.ref)
      : super(
          CommonState(
            data: RegisterState(
              countryFlag: '🇺🇸'.hardcoded,
              countryCode: '+1'.hardcoded,
            ),
          ),
        );

  final Ref ref;

  void onNameChanged(String value) {
    data = data.copyWith(name: value.trim());
  }

  void onPasswordChanged(String value) {
    data = data.copyWith(password: value);
  }

  void onConfirmPasswordChanged(String value) {
    data = data.copyWith(confirmPassword: value);
  }

  void onPhoneNumberChanged(String value) {
    data = data.copyWith(phoneNumber: value.trim());
  }

  void onEmailChanged(String value) {
    data = data.copyWith(email: value.trim());
  }

  void togglePasswordVisibility() {
    data = data.copyWith(isPasswordVisible: !data.isPasswordVisible);
  }

  void toggleConfirmPasswordVisibility() {
    data = data.copyWith(isConfirmPasswordVisible: !data.isConfirmPasswordVisible);
  }

  void onCountryCodeChanged({required String flag, required String code}) {
    data = data.copyWith(countryFlag: flag, countryCode: code);
  }

  bool get isFormValid {
    final hasEmptyFields = data.name.isEmpty ||
        data.password.isEmpty ||
        data.confirmPassword.isEmpty ||
        data.phoneNumber.isEmpty ||
        data.email.isEmpty;
    final isPasswordMatch = data.password == data.confirmPassword;
    // Simple email format check
    final isEmailValid = data.email.contains('@'.hardcoded);

    return !hasEmptyFields && isPasswordMatch && isEmailValid;
  }

  Future<void> onContinuePressed() async {
    if (!isFormValid) {
      return;
    }

    await runCatching(
      action: () async {
        await Future.delayed(const Duration(seconds: 1));

        ref.nav.showSnackBar(
          CommonPopup.successSnackBar('Registration successful!'.hardcoded),
        );
        await ref.nav.replaceAll([const LoginRoute()]);
      },
      handleLoading: true,
    );
  }
}
