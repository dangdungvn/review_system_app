import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../index.dart';

part 'review_state.freezed.dart';

@freezed
sealed class ReviewState extends BaseState with _$ReviewState {
  const ReviewState._();

  const factory ReviewState({
    @Default(<ApiDocumentData>[]) List<ApiDocumentData> documents,
    @Default(<ApiRecommendationData>[]) List<ApiRecommendationData> recommendations,
  }) = _ReviewState;
}
