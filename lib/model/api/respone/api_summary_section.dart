import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_summary_section.freezed.dart';
part 'api_summary_section.g.dart';

@freezed
sealed class ApiSummarySection with _$ApiSummarySection {
  const factory ApiSummarySection({
    @Default('') String heading,
    @Default('') String content,
  }) = _ApiSummarySection;

  factory ApiSummarySection.fromJson(Map<String, dynamic> json) =>
      _$ApiSummarySectionFromJson(json);
}
