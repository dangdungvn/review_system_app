import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../index.dart';

part 'api_summary_data.freezed.dart';
part 'api_summary_data.g.dart';

@freezed
sealed class ApiSummaryData with _$ApiSummaryData {
  const ApiSummaryData._();

  const factory ApiSummaryData({
    required int id,
    required int documentId,
    @Default('') String title,
    @Default('') String overview,
    @Default(<String>[]) List<String> keyPoints,
    @Default(<ApiSummarySection>[]) List<ApiSummarySection> sections,
    @Default(<String>[]) List<String> suggestedQuestions,
    @Default('') String createdAt,
  }) = _ApiSummaryData;

  factory ApiSummaryData.fromJson(Map<String, dynamic> json) => _$ApiSummaryDataFromJson(json);
}
