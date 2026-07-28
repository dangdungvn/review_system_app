import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_recommendation_data.freezed.dart';
part 'api_recommendation_data.g.dart';

@freezed
sealed class ApiRecommendationData with _$ApiRecommendationData {
  const ApiRecommendationData._();

  const factory ApiRecommendationData({
    @Default('') String type,
    @Default(0) int itemId,
    @Default('') String title,
    @Default('') String reason,
    @Default(0) int estimatedTimeMinutes,
  }) = _ApiRecommendationData;

  factory ApiRecommendationData.fromJson(Map<String, dynamic> json) =>
      _$ApiRecommendationDataFromJson(json);
}
