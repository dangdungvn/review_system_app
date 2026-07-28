import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:injectable/injectable.dart';

import '../../../../index.dart';

final appApiServiceProvider = Provider<AppApiService>(
  (ref) => getIt.get<AppApiService>(),
);

@LazySingleton()
class AppApiService {
  AppApiService(
    this._noneAuthAppServerApiClient,
    this._authAppServerApiClient,
    this._randomUserApiClient,
  );
  final NoneAuthAppServerApiClient _noneAuthAppServerApiClient;
  final AuthAppServerApiClient _authAppServerApiClient;
  final RandomUserApiClient _randomUserApiClient;

  Future<void> forgotPassword(String email) async {
    await _noneAuthAppServerApiClient.request(
      method: RestMethod.post,
      path: 'v1/auth/forgot-password',
      body: {
        'email': email,
      },
    );
  }

  Future<void> resetPassword({
    required String token,
    required String email,
    required String password,
  }) async {
    await _noneAuthAppServerApiClient.request(
      method: RestMethod.post,
      path: 'v1/auth/reset-password',
      body: {
        'token': token,
        'email': email,
        'password': password,
        'password_confirmation': password,
      },
    );
  }

  Future<ApiAuthResponseData?> login({
    required String email,
    required String password,
  }) async {
    return _noneAuthAppServerApiClient.request(
      method: RestMethod.post,
      path: 'auth/login',
      body: {
        'email': email,
        'password': password,
      },
      successResponseDecoderType: SuccessResponseDecoderType.jsonObject,
      decoder: (json) {
        final map = safeCast<Map<String, dynamic>>(json) ?? {};
        final dataMap = safeCast<Map<String, dynamic>>(map['data'] ?? map) ?? {};
        return ApiAuthResponseData.fromJson(dataMap);
      },
    );
  }

  Future<void> logout() async {
    await _authAppServerApiClient.request(
      method: RestMethod.post,
      path: 'auth/logout',
      successResponseDecoderType: SuccessResponseDecoderType.plain,
    );
  }

  Future<ApiUserInfo?> getMe() async {
    return _authAppServerApiClient.request(
      method: RestMethod.get,
      path: 'auth/me',
      successResponseDecoderType: SuccessResponseDecoderType.jsonObject,
      decoder: (json) {
        final map = safeCast<Map<String, dynamic>>(json) ?? {};
        final dataMap = safeCast<Map<String, dynamic>>(map['data'] ?? map) ?? {};
        return ApiUserInfo.fromJson(dataMap);
      },
    );
  }

  Future<PagingDataResponse<ApiUserData>?> getUsers({
    required int page,
    required int? limit,
  }) {
    return _randomUserApiClient.request(
      method: RestMethod.get,
      path: '',
      queryParameters: {
        'page': page,
        'results': limit,
      },
      successResponseDecoderType: SuccessResponseDecoderType.paging,
      decoder: (json) => ApiUserData.fromJson(json.safeCast<Map<String, dynamic>>() ?? {}),
    );
  }

  Future<List<ApiDocumentData>> getDocuments({
    required int page,
    required int limit,
  }) async {
    final response = await _authAppServerApiClient.request<List<ApiDocumentData>, List<ApiDocumentData>>(
      method: RestMethod.get,
      path: 'documents',
      queryParameters: {
        'page': page.toString(),
        'limit': limit.toString(),
      },
      successResponseDecoderType: SuccessResponseDecoderType.jsonObject,
      decoder: (json) {
        final map = safeCast<Map<String, dynamic>>(json) ?? {};
        final dataMap = safeCast<Map<String, dynamic>>(map['data'] ?? map) ?? {};
        final items = safeCast<List<Object?>>(dataMap['items'] ?? map['items']) ?? [];
        return items
            .map((e) => ApiDocumentData.fromJson(safeCast<Map<String, dynamic>>(e) ?? {}))
            .toList();
      },
    );
    return response ?? [];
  }

  Future<List<ApiRecommendationData>> getRecommendations() async {
    final response = await _authAppServerApiClient.request<List<ApiRecommendationData>, List<ApiRecommendationData>>(
      method: RestMethod.get,
      path: 'assessment/recommendations',
      successResponseDecoderType: SuccessResponseDecoderType.jsonObject,
      decoder: (json) {
        final map = safeCast<Map<String, dynamic>>(json) ?? {};
        final list = safeCast<List<Object?>>(map['data'] ?? json) ?? [];
        return list
            .map((e) => ApiRecommendationData.fromJson(safeCast<Map<String, dynamic>>(e) ?? {}))
            .toList();
      },
    );
    return response ?? [];
  }

  Future<ApiUserProgressData?> getProgress() async {
    return _authAppServerApiClient.request<ApiUserProgressData, ApiUserProgressData>(
      method: RestMethod.get,
      path: 'assessment/progress',
      successResponseDecoderType: SuccessResponseDecoderType.jsonObject,
      decoder: (json) {
        final map = safeCast<Map<String, dynamic>>(json) ?? {};
        final dataMap = safeCast<Map<String, dynamic>>(map['data'] ?? map) ?? {};
        return ApiUserProgressData.fromJson(dataMap);
      },
    );
  }

  Future<List<ApiReviewActivityData>> getReviewActivities() async {
    final response = await _authAppServerApiClient.request<List<ApiReviewActivityData>, List<ApiReviewActivityData>>(
      method: RestMethod.get,
      path: 'assessment/review-activities',
      successResponseDecoderType: SuccessResponseDecoderType.jsonObject,
      decoder: (json) {
        final map = safeCast<Map<String, dynamic>>(json) ?? {};
        final list = safeCast<List<Object?>>(map['data'] ?? json) ?? [];
        return list
            .map((e) => ApiReviewActivityData.fromJson(safeCast<Map<String, dynamic>>(e) ?? {}))
            .toList();
      },
    );
    return response ?? [];
  }
}
