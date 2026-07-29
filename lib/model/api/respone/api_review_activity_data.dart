import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_review_activity_data.freezed.dart';
part 'api_review_activity_data.g.dart';

@freezed
sealed class ApiReviewActivityData with _$ApiReviewActivityData {
  const ApiReviewActivityData._();

  const factory ApiReviewActivityData({
    @Default('') String id,
    @Default('') String type,
    @Default('') String subjectId,
    @Default('') String subjectTitle,
    @Default('') String exerciseId,
    @Default('') String exerciseTitle,
    @Default('') String documentId,
    @Default('') String startedAt,
    @Default('') String completedAt,
    @Default(0) int durationSeconds,
    @Default(0) int progress,
    @Default(0) int score,
    @Default(0) int correctCount,
    @Default(0) int wrongCount,
    @Default(0) int blankCount,
    @Default(0) int totalItems,
  }) = _ApiReviewActivityData;

  double get accuracy => score.toDouble();
  String get documentTitle => subjectTitle;
  int get correctAnswers => correctCount;
  int get totalQuestions => totalItems;
  int get timeSpent => durationSeconds;
  String get date => startedAt.isNotEmpty ? startedAt : completedAt;

  factory ApiReviewActivityData.fromJson(Map<String, dynamic> json) =>
      _$ApiReviewActivityDataFromJson(json);
}
