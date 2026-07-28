import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../index.dart';

part 'statistics_state.freezed.dart';

@freezed
sealed class StatisticsState extends BaseState with _$StatisticsState {
  const StatisticsState._();

  const factory StatisticsState({
    @Default(ApiUserProgressData()) ApiUserProgressData progress,
    @Default(<ApiReviewActivityData>[]) List<ApiReviewActivityData> activities,
  }) = _StatisticsState;
}
