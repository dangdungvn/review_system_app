import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../index.dart';

part 'subject_detail_state.freezed.dart';

@freezed
sealed class SubjectDetailState extends BaseState with _$SubjectDetailState {
  const SubjectDetailState._();

  const factory SubjectDetailState({
    required ApiDocumentData document,
    @Default(<ApiReviewActivityData>[]) List<ApiReviewActivityData> activities,
  }) = _SubjectDetailState;
}
