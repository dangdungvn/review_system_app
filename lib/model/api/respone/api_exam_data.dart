import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_exam_data.freezed.dart';
part 'api_exam_data.g.dart';

@freezed
sealed class ApiExamData with _$ApiExamData {
  const ApiExamData._();

  const factory ApiExamData({
    @Default(0) int id,
    @Default(0) int documentId,
    @Default('') String title,
    @Default(0) int totalQuestions,
    @Default('') String status,
    @Default('') String createdAt,
  }) = _ApiExamData;

  factory ApiExamData.fromJson(Map<String, dynamic> json) => _$ApiExamDataFromJson(json);
}
