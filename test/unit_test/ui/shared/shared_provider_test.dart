import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nalsflutter/index.dart';

import '../../../common/index.dart';

void main() {
  group('languageCodeProvider', () {
    test('when `appPreferences.languageCode` is not empty', () {
      when(() => appPreferences.languageCode).thenReturn(Constant.en);
      when(() => appPreferences.saveLanguageCode(Constant.en)).thenAnswer((_) async => true);
      final expectedValue = LanguageCode.fromValue(Constant.en);

      final container = TestUtil.createContainer(
        overrides: [
          appPreferencesProvider.overrideWith((_) => appPreferences),
        ],
      );

      final result = container.read(languageCodeProvider);
      expect(result, expectedValue);
      verify(() => appPreferences.saveLanguageCode(Constant.en)).called(1);
    });

    test('when `appPreferences.languageCode` is empty', () {
      when(() => appPreferences.languageCode).thenReturn('');
      when(() => appPreferences.saveLanguageCode(LanguageCode.defaultValue.value))
          .thenAnswer((_) async => true);
      const expectedValue = LanguageCode.defaultValue;

      final container = TestUtil.createContainer(
        overrides: [
          appPreferencesProvider.overrideWith((_) => appPreferences),
        ],
      );

      final result = container.read(languageCodeProvider);
      expect(result, expectedValue);
      verify(() => appPreferences.saveLanguageCode(LanguageCode.defaultValue.value)).called(1);
    });
  });

  group('isDarkModeProvider', () {
    test('when `appPreferences.isDarkMode` is not empty', () {
      when(() => appPreferences.isDarkMode).thenReturn(true);
      when(() => appPreferences.saveIsDarkMode(true)).thenAnswer((_) async => true);
      const expectedValue = true;

      final container = TestUtil.createContainer(
        overrides: [
          appPreferencesProvider.overrideWith((_) => appPreferences),
        ],
      );

      final result = container.read(isDarkModeProvider);
      expect(result, expectedValue);
      verify(() => appPreferences.saveIsDarkMode(true)).called(1);
    });

    test('when `appPreferences.isDarkMode` is empty', () {
      when(() => appPreferences.isDarkMode).thenReturn(false);
      when(() => appPreferences.saveIsDarkMode(false)).thenAnswer((_) async => true);
      const expectedValue = false;

      final container = TestUtil.createContainer(
        overrides: [
          appPreferencesProvider.overrideWith((_) => appPreferences),
        ],
      );

      final result = container.read(isDarkModeProvider);
      expect(result, expectedValue);
      verify(() => appPreferences.saveIsDarkMode(false)).called(1);
    });
  });
}
