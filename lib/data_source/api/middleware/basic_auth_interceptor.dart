import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../index.dart';

class BasicAuthInterceptor extends BaseInterceptor {
  BasicAuthInterceptor({
    this.username = Env.appBasicAuthName,
    this.password = Env.appBasicAuthPassword,
    AppPreferences? appPreferences,
  })  : _appPreferences = appPreferences,
        super(InterceptorType.basicAuth);

  final String username;
  final String password;
  final AppPreferences? _appPreferences;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.headers[Constant.basicAuthorization] == null) {
      options.headers[Constant.basicAuthorization] = _basicAuthenticationHeader();
    }

    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    try {
      await _saveCookies(response);
    } catch (e) {
      Log.e('Error saving cookies in BasicAuthInterceptor: $e'.hardcoded);
    }
    handler.next(response);
  }

  Future<void> _saveCookies(Response response) async {
    final prefs = _appPreferences ??
        (getIt.isRegistered<AppPreferences>() ? getIt.get<AppPreferences>() : null);
    if (prefs == null) {
      return;
    }
    final setCookie = response.headers['set-cookie'];
    if (setCookie == null) {
      return;
    }
    for (final cookie in setCookie) {
      final parts = cookie.split(';');
      if (parts.isEmpty) {
        continue;
      }
      final keyValue = parts[0].split('=');
      if (keyValue.length < 2) {
        continue;
      }
      final key = keyValue[0].trim();
      final value = keyValue.sublist(1).join('=').trim();
      if (key == 'access_token') {
        await prefs.saveAccessToken(value);
        await prefs.saveIsLoggedIn(true);
      } else if (key == 'refresh_token') {
        await prefs.saveRefreshToken(value);
      }
    }
  }

  String _basicAuthenticationHeader() {
    return 'Basic ${base64Encode(utf8.encode('$username:$password'))}';
  }
}
