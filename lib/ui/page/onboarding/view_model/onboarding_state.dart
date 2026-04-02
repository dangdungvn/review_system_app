import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../index.dart';

part 'onboarding_state.freezed.dart';

@freezed
sealed class OnboardingState extends BaseState with _$OnboardingState {
  const OnboardingState._();

  const factory OnboardingState({
    @Default(0) int currentPage,
  }) = _OnboardingState;
}
