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
        CommonTextField(
          hintText: l10n.registerNamePlaceholder,
          onChanged: ref.read(provider.notifier).onNameChanged,
        ),
        SizedBox(height: 16.rps),
        CommonTextField(
          hintText: l10n.registerPasswordPlaceholder,
          obscureText: !state.isPasswordVisible,
          onChanged: ref.read(provider.notifier).onPasswordChanged,
          suffixIcon: IconButton(
            onPressed: ref.read(provider.notifier).togglePasswordVisibility,
            icon: Icon(
              state.isPasswordVisible ? AppIcons.showBold : AppIcons.hideBold,
              color: color.greyscale500,
              size: 20.rps,
            ),
          ),
        ),
        SizedBox(height: 16.rps),
        CommonTextField(
          hintText: l10n.registerConfirmPasswordPlaceholder,
          obscureText: !state.isConfirmPasswordVisible,
          onChanged: ref.read(provider.notifier).onConfirmPasswordChanged,
          suffixIcon: IconButton(
            onPressed: ref.read(provider.notifier).toggleConfirmPasswordVisibility,
            icon: Icon(
              state.isConfirmPasswordVisible ? AppIcons.showBold : AppIcons.hideBold,
              color: color.greyscale500,
              size: 20.rps,
            ),
          ),
        ),
        SizedBox(height: 16.rps),
        CommonTextField(
          hintText: l10n.registerPhoneNumberPlaceholder,
          keyboardType: TextInputType.phone,
          onChanged: ref.read(provider.notifier).onPhoneNumberChanged,
          prefixIcon: GestureDetector(
            onTap: () => _showCountryPicker(context: context, ref: ref),
            child: Padding(
              padding: EdgeInsets.only(left: 16.rps, right: 8.rps),
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
        ),
        SizedBox(height: 16.rps),
        CommonTextField(
          hintText: l10n.registerEmailPlaceholder,
          keyboardType: TextInputType.emailAddress,
          onChanged: ref.read(provider.notifier).onEmailChanged,
        ),
      ],
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
