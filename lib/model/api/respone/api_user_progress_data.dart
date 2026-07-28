import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_user_progress_data.freezed.dart';
part 'api_user_progress_data.g.dart';

@freezed
sealed class ApiUserProgressData with _$ApiUserProgressData {
  const ApiUserProgressData._();

  const factory ApiUserProgressData({
    @Default(0) int examsCompleted,
    @Default(0) int flashcardsMastered,
    @Default(0) int currentStreak,
    @Default('') String motivationalMessage,
    @Default(0.0) double averageAccuracy,
  }) = _ApiUserProgressData;

  factory ApiUserProgressData.fromJson(Map<String, dynamic> json) =>
      _$ApiUserProgressDataFromJson(json);
}
