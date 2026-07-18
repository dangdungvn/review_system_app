import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import '../../../index.dart';

@RoutePage()
class RegisterPage extends BasePage<RegisterState,
    AutoDisposeStateNotifierProvider<RegisterViewModel, CommonState<RegisterState>>> {
  const RegisterPage({super.key});

  @override
  ScreenViewEvent get screenViewEvent => ScreenViewEvent(screenName: ScreenName.registerPage);

  @override
  AutoDisposeStateNotifierProvider<RegisterViewModel, CommonState<RegisterState>> get provider =>
      registerViewModelProvider;

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
                      routeName: 'RegisterRoute'.hardcoded,
                      controller: scrollController,
                      child: SingleChildScrollView(
                        controller: scrollController,
                        physics: const ClampingScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: 24.rps),
                        child: Column(
                          children: [
                            SizedBox(height: 24.rps),
                            _buildIllustration(),
                            SizedBox(height: 24.rps),
                            _buildForm(context: context, ref: ref, state: state),
                            SizedBox(height: 48.rps),
                          ],
                        ),
                      ),
                    ),
                  ),
                  _buildSubmitButton(ref: ref, isFormValid: isFormValid),
                ],
              ),
              _buildNavbar(context: context, ref: ref),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavbar({required BuildContext context, required WidgetRef ref}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.rps, vertical: 12.rps),
      child: SizedBox(
        height: 48.rps,
        child: Row(
          children: [
            GlassIconButton(
              icon: const Icon(AppIcons.arrowLeftLight),
              onPressed: () => ref.read(appNavigatorProvider).pop(),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildIllustration() {
    return CommonImage.asset(
      path: image.registerIllustration,
      width: 330.rps,
      height: 200.rps,
      fit: BoxFit.cover,
    );
  }

  Widget _buildForm({
    required BuildContext context,
    required WidgetRef ref,
    required RegisterState state,
  }) {
    return Column(
      children: [
        _buildTextField(
          hintText: l10n.registerNamePlaceholder,
          onChanged: ref.read(provider.notifier).onNameChanged,
        ),
        SizedBox(height: 16.rps),
        _buildPasswordField(
          hintText: l10n.registerPasswordPlaceholder,
          isObscured: !state.isPasswordVisible,
          onChanged: ref.read(provider.notifier).onPasswordChanged,
          onToggleVisibility: ref.read(provider.notifier).togglePasswordVisibility,
        ),
        SizedBox(height: 16.rps),
        _buildPasswordField(
          hintText: l10n.registerConfirmPasswordPlaceholder,
          isObscured: !state.isConfirmPasswordVisible,
          onChanged: ref.read(provider.notifier).onConfirmPasswordChanged,
          onToggleVisibility: ref.read(provider.notifier).toggleConfirmPasswordVisibility,
        ),
        SizedBox(height: 16.rps),
        _buildPhoneNumberField(context: context, ref: ref, state: state),
        SizedBox(height: 16.rps),
        _buildEmailField(ref),
      ],
    );
  }

  Widget _buildTextField({
    required String hintText,
    required ValueChanged<String> onChanged,
  }) {
    return Container(
      height: 56.rps,
      decoration: BoxDecoration(
        color: color.greyscale50,
        borderRadius: BorderRadius.circular(12.rps),
      ),
      child: TextField(
        onChanged: onChanged,
        style: style(
          color: color.greyscale900,
          fontSize: 14.rps,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20.rps, vertical: 18.rps),
          hintText: hintText,
          hintStyle: style(
            color: color.greyscale500,
            fontSize: 14.rps,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required String hintText,
    required bool isObscured,
    required ValueChanged<String> onChanged,
    required VoidCallback onToggleVisibility,
  }) {
    return Container(
      height: 56.rps,
      decoration: BoxDecoration(
        color: color.greyscale50,
        borderRadius: BorderRadius.circular(12.rps),
      ),
      alignment: Alignment.center,
      child: TextField(
        obscureText: isObscured,
        onChanged: onChanged,
        style: style(
          color: color.greyscale900,
          fontSize: 14.rps,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20.rps, vertical: 18.rps),
          hintText: hintText,
          hintStyle: style(
            color: color.greyscale500,
            fontSize: 14.rps,
            fontWeight: FontWeight.w400,
          ),
          suffixIcon: IconButton(
            onPressed: onToggleVisibility,
            icon: Icon(
              isObscured ? AppIcons.hideBold : AppIcons.showBold,
              color: color.greyscale500,
              size: 20.rps,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneNumberField({
    required BuildContext context,
    required WidgetRef ref,
    required RegisterState state,
  }) {
    return Container(
      height: 56.rps,
      decoration: BoxDecoration(
        color: color.greyscale50,
        borderRadius: BorderRadius.circular(12.rps),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _showCountryPicker(context: context, ref: ref),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.rps),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CommonText(
                    state.countryFlag,
                    style: style(fontSize: 18.rps, color: color.black),
                  ),
                  SizedBox(width: 4.rps),
                  Icon(AppIcons.arrowDown2Light, size: 16.rps, color: color.greyscale700),
                  SizedBox(width: 8.rps),
                  Container(width: 1.rps, height: 20.rps, color: color.greyscale300),
                ],
              ),
            ),
          ),
          Expanded(
            child: TextField(
              keyboardType: TextInputType.phone,
              onChanged: ref.read(provider.notifier).onPhoneNumberChanged,
              style: style(
                color: color.greyscale900,
                fontSize: 14.rps,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 18.rps),
                hintText: l10n.registerPhoneNumberPlaceholder,
                hintStyle: style(
                  color: color.greyscale500,
                  fontSize: 14.rps,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailField(WidgetRef ref) {
    return Container(
      height: 56.rps,
      decoration: BoxDecoration(
        color: color.greyscale50,
        borderRadius: BorderRadius.circular(12.rps),
      ),
      alignment: Alignment.center,
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        onChanged: ref.read(provider.notifier).onEmailChanged,
        style: style(
          color: color.greyscale900,
          fontSize: 14.rps,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20.rps, vertical: 18.rps),
          hintText: l10n.registerEmailPlaceholder,
          hintStyle: style(
            color: color.greyscale500,
            fontSize: 14.rps,
            fontWeight: FontWeight.w400,
          ),
          suffixIcon: Icon(
            AppIcons.messageLight,
            color: color.greyscale500,
            size: 20.rps,
          ),
        ),
      ),
    );
  }

  void _showCountryPicker({required BuildContext context, required WidgetRef ref}) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.rps)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: CommonText(
                  '🇺🇸'.hardcoded,
                  style: style(fontSize: 24.rps, color: color.black),
                ),
                title: CommonText(
                  'United States (+1)'.hardcoded,
                  style: style(
                      fontSize: 16.rps, color: color.greyscale900, fontWeight: FontWeight.w600),
                ),
                onTap: () {
                  ref.read(provider.notifier).onCountryCodeChanged(
                        flag: '🇺🇸'.hardcoded,
                        code: '+1'.hardcoded,
                      );
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: CommonText(
                  '🇻🇳'.hardcoded,
                  style: style(fontSize: 24.rps, color: color.black),
                ),
                title: CommonText(
                  'Vietnam (+84)'.hardcoded,
                  style: style(
                      fontSize: 16.rps, color: color.greyscale900, fontWeight: FontWeight.w600),
                ),
                onTap: () {
                  ref.read(provider.notifier).onCountryCodeChanged(
                        flag: '🇻🇳'.hardcoded,
                        code: '+84'.hardcoded,
                      );
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSubmitButton({required WidgetRef ref, required bool isFormValid}) {
    return Padding(
      padding: EdgeInsets.only(left: 24.rps, right: 24.rps, bottom: 24.rps),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: isFormValid ? () => ref.read(provider.notifier).onContinuePressed() : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: color.primary,
            disabledBackgroundColor: color.primary.withValues(alpha: 0.5),
            foregroundColor: color.white,
            disabledForegroundColor: color.white.withValues(alpha: 0.8),
            padding: EdgeInsets.symmetric(vertical: 18.rps, horizontal: 16.rps),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.rps)),
            elevation: 0,
          ),
          child: CommonText(
            l10n.registerContinue,
            style: style(
              color: color.white.withValues(alpha: isFormValid ? 1.0 : 0.8),
              fontSize: 16.rps,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2.rps,
            ),
          ),
        ),
      ),
    );
  }
}
