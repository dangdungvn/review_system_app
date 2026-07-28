import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../index.dart';

final appPreferencesProvider = Provider((ref) => getIt.get<AppPreferences>());

@LazySingleton()
class AppPreferences {
  AppPreferences(this._sharedPreference);

  final SharedPreferences _sharedPreference;

  // keys should be removed when logout
  static const keyAccessToken = 'accessToken';
  static const keyRefreshToken = 'refreshToken';
  static const keyUserId = 'userId';
  static const keyEmail = 'email';
  static const keyPassword = 'password';
  static const keyDeviceToken = 'deviceToken';
  static const keyIsLoggedIn = 'isLoggedIn';
  static const keyAvatarUrl = 'avatarUrl';

  // keys should not be removed when logout
  static const keyIsDarkMode = 'isDarkMode';
  static const keyLanguageCode = 'languageCode';
  static const keyNickName = 'nickName';
  static const keyHasSeenOnboarding = 'hasSeenOnboarding';

  Future<bool> saveHasSeenOnboarding({required bool hasSeenOnboarding}) {
    return _sharedPreference.setBool(keyHasSeenOnboarding, hasSeenOnboarding);
  }

  bool get hasSeenOnboarding {
    return _sharedPreference.getBool(keyHasSeenOnboarding) ?? false;
  }

  Future<bool> saveIsDarkMode(bool isDarkMode) {
    return _sharedPreference.setBool(keyIsDarkMode, isDarkMode);
  }

  bool get isDarkMode {
    return _sharedPreference.getBool(keyIsDarkMode) ?? false;
  }

  Future<bool> saveLanguageCode(String languageCode) {
    return _sharedPreference.setString(keyLanguageCode, languageCode);
  }

  String get languageCode =>
      _sharedPreference.getString(keyLanguageCode) ?? LanguageCode.defaultValue.localeCode;

  Future<bool> saveDeviceToken(String token) {
    return _sharedPreference.setString(keyDeviceToken, token);
  }

  String get deviceToken {
    return _sharedPreference.getString(keyDeviceToken) ?? '';
  }

  Future<void> saveAccessToken(String token) async {
    await _sharedPreference.setString(keyAccessToken, token);
  }

  Future<String> get accessToken {
    return Future.value(_sharedPreference.getString(keyAccessToken) ?? '');
  }

  Future<void> saveIsLoggedIn(bool isLoggedIn) async {
    await _sharedPreference.setBool(keyIsLoggedIn, isLoggedIn);
  }

  bool get isLoggedIn {
    return _sharedPreference.getBool(keyIsLoggedIn) ?? false;
  }

  Future<void> saveRefreshToken(String token) async {
    await _sharedPreference.setString(keyRefreshToken, token);
  }

  Future<String> get refreshToken {
    return Future.value(_sharedPreference.getString(keyRefreshToken) ?? '');
  }

  Future<bool> saveUserId(String userId) {
    return _sharedPreference.setString(keyUserId, userId);
  }

  String get userId {
    return _sharedPreference.getString(keyUserId) ?? '';
  }

  Future<bool> saveEmail(String email) {
    return _sharedPreference.setString(keyEmail, email);
  }

  String get email {
    return _sharedPreference.getString(keyEmail) ?? '';
  }

  Future<void> savePassword(String password) async {
    await _sharedPreference.setString(keyPassword, password);
  }

  Future<String?> get password {
    return Future.value(_sharedPreference.getString(keyPassword));
  }

  Future<bool> saveUserNickname({
    required String conversationId,
    required String memberId,
    required String nickname,
  }) {
    final key = '$keyNickName/$userId/$conversationId/$memberId';

    return _sharedPreference.setString(key, nickname.trim());
  }

  String? getUserNickname({
    required String conversationId,
    required String memberId,
  }) {
    final key = '$keyNickName/$userId/$conversationId/$memberId';

    return _sharedPreference.getString(key);
  }

  Future<bool> saveAvatarUrl(String avatarUrl) {
    return _sharedPreference.setString(keyAvatarUrl, avatarUrl);
  }

  String get avatarUrl {
    return _sharedPreference.getString(keyAvatarUrl) ?? '';
  }

  Future<void> clearCurrentUserData() async {
    await Future.wait(
      [
        _sharedPreference.remove(keyAccessToken),
        _sharedPreference.remove(keyRefreshToken),
        _sharedPreference.remove(keyDeviceToken),
        _sharedPreference.remove(keyUserId),
        _sharedPreference.remove(keyEmail),
        _sharedPreference.remove(keyPassword),
        _sharedPreference.remove(keyIsLoggedIn),
        _sharedPreference.remove(keyAvatarUrl),
      ],
    );
  }
}
