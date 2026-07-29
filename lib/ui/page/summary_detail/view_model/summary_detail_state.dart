import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../index.dart';

part 'summary_detail_state.freezed.dart';

@freezed
sealed class SummaryDetailState extends BaseState with _$SummaryDetailState {
  const SummaryDetailState._();

  const factory SummaryDetailState({
    required ApiDocumentData document,
    required int summaryId,
    ApiSummaryData? summary,
  }) = _SummaryDetailState;
}
