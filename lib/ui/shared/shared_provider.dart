// ignore_for_file: deprecated_member_use

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../index.dart';

final languageCodeProvider = StateProvider<LanguageCode>(
  (ref) {
    ref.listenSelf((previous, next) {
      ref.appPreferences.saveLanguageCode(next.value);
    });

    return LanguageCode.fromValue(ref.appPreferences.languageCode);
  },
);

final isDarkModeProvider = StateProvider<bool>(
  (ref) {
    ref.listenSelf((previous, next) {
      ref.appPreferences.saveIsDarkMode(next);
    });

    return ref.appPreferences.isDarkMode;
  },
);

final currentUserProvider = StateProvider<FirebaseUserData>(
  (ref) {
    ref.listenSelf((previous, next) {
      ref.appPreferences.saveUserId(next.id);
      ref.appPreferences.saveEmail(next.email);
    });

    return const FirebaseUserData();
  },
);
