import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_refresh_token_data.freezed.dart';
part 'api_refresh_token_data.g.dart';

@freezed
sealed class ApiRefreshTokenData with _$ApiRefreshTokenData {
  const ApiRefreshTokenData._();

  const factory ApiRefreshTokenData({
    @JsonKey(name: 'accessToken') String? accessToken,
    @JsonKey(name: 'refreshToken') String? refreshToken,
  }) = _ApiRefreshTokenData;

  factory ApiRefreshTokenData.fromJson(Map<String, dynamic> json) =>
      _$ApiRefreshTokenDataFromJson(json);
}
