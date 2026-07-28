import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_auth_response_data.freezed.dart';
part 'api_auth_response_data.g.dart';

@freezed
sealed class ApiUserInfo with _$ApiUserInfo {
  const ApiUserInfo._();

  const factory ApiUserInfo({
    @Default('') String id,
    @Default('') String email,
    @Default('') String fullName,
    @Default('') String role,
    String? avatarUrl,
  }) = _ApiUserInfo;

  factory ApiUserInfo.fromJson(Map<String, dynamic> json) => _$ApiUserInfoFromJson(json);
}

@freezed
sealed class ApiAuthResponseData with _$ApiAuthResponseData {
  const ApiAuthResponseData._();

  const factory ApiAuthResponseData({
    @Default('') String accessToken,
    @Default('') String refreshToken,
    @Default(ApiUserInfo()) ApiUserInfo user,
  }) = _ApiAuthResponseData;

  factory ApiAuthResponseData.fromJson(Map<String, dynamic> json) =>
      _$ApiAuthResponseDataFromJson(json);
}
