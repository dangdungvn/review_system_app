import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../index.dart';

part 'review_method_state.freezed.dart';

@freezed
sealed class ReviewMethodState extends BaseState with _$ReviewMethodState {
  const ReviewMethodState._();

  const factory ReviewMethodState({
    required ApiDocumentData document,
    @Default(<ApiSummaryData>[]) List<ApiSummaryData> summaries,
  }) = _ReviewMethodState;
}
