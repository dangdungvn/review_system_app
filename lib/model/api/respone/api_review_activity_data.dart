import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_review_activity_data.freezed.dart';
part 'api_review_activity_data.g.dart';

@freezed
sealed class ApiReviewActivityData with _$ApiReviewActivityData {
  const ApiReviewActivityData._();

  const factory ApiReviewActivityData({
    @Default('') String id,
    @JsonKey(name: 'startedAt') @Default('') String date,
    @JsonKey(name: 'score') @Default(0.0) double accuracy,
    @JsonKey(name: 'durationSeconds') @Default(0) int timeSpent,
    @JsonKey(name: 'correctCount') @Default(0) int correctAnswers,
    @JsonKey(name: 'totalItems') @Default(0) int totalQuestions,
    @JsonKey(name: 'documentId') String? documentIdStr,
    @JsonKey(name: 'subjectTitle') String? documentTitle,
    @Default('') String type,
  }) = _ApiReviewActivityData;

  int? get documentId => int.tryParse(documentIdStr ?? '');

  factory ApiReviewActivityData.fromJson(Map<String, dynamic> json) =>
      _$ApiReviewActivityDataFromJson(json);
}
