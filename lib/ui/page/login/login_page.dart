// ignore_for_file: missing_common_scrollbar, avoid_hard_coded_colors, avoid_hard_coded_strings
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import '../../../index.dart';

@RoutePage()
class LoginPage extends BasePage<LoginState,
    AutoDisposeStateNotifierProvider<LoginViewModel, CommonState<LoginState>>> {
  const LoginPage({super.key});

  @override
  ScreenViewEvent get screenViewEvent => ScreenViewEvent(screenName: ScreenName.loginPage);

  @override
  AutoDisposeStateNotifierProvider<LoginViewModel, CommonState<LoginState>> get provider =>
      loginViewModelProvider;

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    final state = ref.watch(provider).data;
    final isFormValid = ref.watch(provider.notifier).isFormValid;

    return CommonScaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: CommonScrollbarWithIosStatusBarTapDetector(
                      routeName: 'LoginRoute'.hardcoded,
                      controller: scrollController,
                      child: SingleChildScrollView(
                        controller: scrollController,
                        physics: const ClampingScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: 24.rps),
                        child: Column(
                          children: [
                            SizedBox(height: 72.rps),
                            CommonText(
                              l10n.loginTitle,
                              style: style(
                                color: color.black,
                                fontSize: 32.rps,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 36.rps),
                            _buildForm(ref: ref, state: state),
                            SizedBox(height: 16.rps),
                            _buildRememberPasswordRow(ref: ref, state: state),
                            SizedBox(height: 24.rps),
                            _buildSubmitButton(ref: ref, isFormValid: isFormValid),
                            SizedBox(height: 16.rps),
                            _buildForgotPasswordLink(),
                            SizedBox(height: 32.rps),
                            _buildDivider(),
                            SizedBox(height: 24.rps),
                            _buildSocialLogins(),
                            SizedBox(height: 36.rps),
                            _buildFooterLink(ref: ref),
                            SizedBox(height: 24.rps),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              _buildNavbar(ref: ref),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavbar({required WidgetRef ref}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.rps, vertical: 12.rps),
      child: SizedBox(
        height: 48.rps,
        child: Row(
          children: [
            GlassIconButton(
              icon: const Icon(AppIcons.arrowLeftLight),
              onPressed: () => ref.read(appNavigatorProvider).pop(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm({
    required WidgetRef ref,
    required LoginState state,
  }) {
    return Column(
      children: [
        // Username / Email input field
        CommonTextField(
          hintText: l10n.loginUsernamePlaceholder,
          onChanged: ref.read(provider.notifier).onUsernameChanged,
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: 16.rps, right: 12.rps),
            child: Icon(
              AppIcons.messageLight,
              color: color.greyscale500,
              size: 20.rps,
            ),
          ),
        ),
        SizedBox(height: 16.rps),
        // Password input field
        CommonTextField(
          hintText: l10n.loginPasswordPlaceholder,
          obscureText: !state.isPasswordVisible,
          onChanged: ref.read(provider.notifier).onPasswordChanged,
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: 16.rps, right: 12.rps),
            child: Icon(
              AppIcons.lockLight,
              color: color.greyscale500,
              size: 20.rps,
            ),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              state.isPasswordVisible ? AppIcons.showBold : AppIcons.hideBold,
              color: color.greyscale500,
              size: 20.rps,
            ),
            onPressed: ref.read(provider.notifier).onTogglePasswordVisibility,
          ),
        ),
      ],
    );
  }

  Widget _buildRememberPasswordRow({
    required WidgetRef ref,
    required LoginState state,
  }) {
    return GestureDetector(
      onTap: ref.read(provider.notifier).onToggleRememberPassword,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 20.rps,
            height: 20.rps,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.rps),
              border: Border.all(
                color: state.rememberPassword ? color.primary : color.greyscale500,
                width: 2.rps,
              ),
              color: state.rememberPassword ? color.primary : Colors.transparent,
            ),
            child: state.rememberPassword
                ? Icon(
                    Icons.check,
                    size: 14.rps,
                    color: color.white,
                  )
                : null,
          ),
          SizedBox(width: 8.rps),
          CommonText(
            l10n.loginRememberPassword,
            style: style(
              color: color.black,
              fontSize: 14.rps,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton({
    required WidgetRef ref,
    required bool isFormValid,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56.rps,
      child: ElevatedButton(
        onPressed: isFormValid ? ref.read(provider.notifier).onLoginPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: color.primary,
          disabledBackgroundColor: color.primary.withValues(alpha: 0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100.rps),
          ),
          elevation: 0,
        ),
        child: CommonText(
          l10n.loginSubmit,
          style: style(
            color: color.white,
            fontSize: 16.rps,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildForgotPasswordLink() {
    return GestureDetector(
      onTap: () {},
      child: CommonText(
        l10n.loginForgotPassword,
        style: style(
          color: color.primary,
          fontSize: 14.rps,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1.rps,
            color: color.greyscale200,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.rps),
          child: CommonText(
            l10n.loginOr,
            style: style(
              color: color.greyscale500,
              fontSize: 14.rps,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1.rps,
            color: color.greyscale200,
          ),
        ),
      ],
    );
  }

  Widget _buildSocialLogins() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSocialButton(
          child: Icon(Icons.facebook, color: const Color(0xFF1877F2), size: 28.rps),
          onTap: () {},
        ),
        SizedBox(width: 16.rps),
        _buildSocialButton(
          child: Icon(Icons.g_mobiledata, color: const Color(0xFFEA4335), size: 36.rps),
          onTap: () {},
        ),
        SizedBox(width: 16.rps),
        _buildSocialButton(
          child: Icon(Icons.apple, color: color.black, size: 28.rps),
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required Widget child,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64.rps,
        height: 64.rps,
        decoration: BoxDecoration(
          color: color.white,
          borderRadius: BorderRadius.circular(16.rps),
          border: Border.all(color: color.greyscale200, width: 1.5.rps),
        ),
        child: Center(child: child),
      ),
    );
  }

  Widget _buildFooterLink({required WidgetRef ref}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CommonText(
          l10n.loginNoAccountPrompt,
          style: style(
            color: color.greyscale500,
            fontSize: 14.rps,
            fontWeight: FontWeight.w400,
          ),
        ),
        GestureDetector(
          onTap: ref.read(provider.notifier).onRegisterPressed,
          child: CommonText(
            l10n.loginRegisterNow,
            style: style(
              color: color.primary,
              fontSize: 14.rps,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
