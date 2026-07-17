import 'dart:io';
import 'dart:math';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:injectable/injectable.dart';

import '../../index.dart';

final deviceHelperProvider = Provider<DeviceHelper>(
  (ref) => getIt.get<DeviceHelper>(),
);

enum DeviceType { smallPhone, phone, tablet }

@LazySingleton()
class DeviceHelper {
  static const _kDeviceIdKey = 'device_id';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<String> get deviceId async {
    final existing = await _storage.read(key: _kDeviceIdKey);
    if (existing != null && existing.isNotEmpty) return existing;
    final generated = _generateUdid();
    await _storage.write(key: _kDeviceIdKey, value: generated);
    return generated;
  }

  String _generateUdid() {
    final rand = Random.secure();
    final bytes = List<int>.generate(16, (_) => rand.nextInt(256));
    // RFC 4122 v4 layout — high nibble = 4, clock_seq_hi variant = 10xx
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    bytes[8] = (bytes[8] & 0x3f) | 0x80;
    final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    return '${hex.substring(0, 8)}-'
        '${hex.substring(8, 12)}-'
        '${hex.substring(12, 16)}-'
        '${hex.substring(16, 20)}-'
        '${hex.substring(20, 32)}';
  }

  Future<String> get deviceModelName async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;

      return iosInfo.name;
    } else {
      final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

      return '${androidInfo.brand} ${androidInfo.device}';
    }
  }

  DeviceType get deviceType {
    const _phoneMaxWidth = 550;
    const _smallPhoneMaxWidth = 380;

    final deviceWidth =
        MediaQueryData.fromView(WidgetsBinding.instance.platformDispatcher.views.first)
            .size
            .shortestSide;
    return deviceWidth < _smallPhoneMaxWidth
        ? DeviceType.smallPhone
        : deviceWidth < _phoneMaxWidth
            ? DeviceType.phone
            : DeviceType.tablet;
  }

  String get operatingSystem => Platform.operatingSystem;
}
