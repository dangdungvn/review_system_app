import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nalsflutter/index.dart';

import '../../../common/index.dart';

void main() {
  late SharedViewModel sharedViewModel;

  setUp(() {
    sharedViewModel = SharedViewModel(ref);
  });

  group('deviceToken', () {
    test('when `firebaseMessagingService.deviceToken` returns a non-null value', () async {
      const dummyDeviceToken = 'token123';
      const expectedDeviceToken = 'token123';

      when(() => firebaseMessagingService.deviceToken).thenAnswer((_) async => dummyDeviceToken);
      when(() => appPreferences.saveDeviceToken(dummyDeviceToken)).thenAnswer((_) async => true);
      final result = await sharedViewModel.deviceToken;

      expect(result, expectedDeviceToken);
      verify(() => appPreferences.saveDeviceToken(dummyDeviceToken)).called(1);
    });

    test('when `firebaseMessagingService.deviceToken` returns null', () async {
      const String? dummyDeviceToken = null;
      const expectedDeviceToken = '';

      when(() => firebaseMessagingService.deviceToken).thenAnswer((_) async => dummyDeviceToken);
      final result = await sharedViewModel.deviceToken;

      expect(result, expectedDeviceToken);
      verifyNever(() => appPreferences.saveDeviceToken(any()));
    });

    test('when `firebaseMessagingService.deviceToken` throws an error', () async {
      final dummyError = Exception();

      when(() => firebaseMessagingService.deviceToken).thenThrow(dummyError);

      expect(await sharedViewModel.deviceToken, '');
      verifyNever(() => appPreferences.saveDeviceToken(any()));
    });
  });

  group('logout', () {
    const dummyDeviceToken = 'token123';
    const dummyUserId = 'userId';
    const dummyUserData = FirebaseUserData(
      id: dummyUserId,
      deviceIds: [],
      deviceTokens: [dummyDeviceToken],
    );

    setUp(() {
      when(() => firebaseMessagingService.deviceToken).thenAnswer((_) async => dummyDeviceToken);
      when(() => appPreferences.saveDeviceToken(dummyDeviceToken)).thenAnswer((_) async => true);
      when(() => appPreferences.userId).thenReturn(dummyUserId);
      when(() => firebaseFirestoreService.updateCurrentUser(
            userId: dummyUserId,
            data: {
              FirebaseUserData.keyDeviceIds: [],
              FirebaseUserData.keyDeviceTokens: FieldValue.arrayRemove([dummyDeviceToken]),
            },
          )).thenAnswer((_) async => true);
      when(() => appPreferences.clearCurrentUserData()).thenAnswer((_) async => true);
      when(() => firebaseAuthService.signOut()).thenAnswer((_) async => true);
      when(() => currentUserStateController.update(any())).thenReturn(dummyUserData);
      when(() => navigator.replaceAll([const LoginRoute()])).thenAnswer((_) async => true);
    });

    test('when logout success', () async {
      await sharedViewModel.logout();

      verify(() => firebaseFirestoreService.updateCurrentUser(
            userId: dummyUserId,
            data: {
              FirebaseUserData.keyDeviceIds: [],
              FirebaseUserData.keyDeviceTokens: FieldValue.arrayRemove([dummyDeviceToken]),
            },
          )).called(1);
      verify(() => appPreferences.clearCurrentUserData()).called(1);
      verify(() => firebaseAuthService.signOut()).called(1);
      verify(() => currentUserStateController.update(any())).called(1);
      verify(() => navigator.replaceAll([const LoginRoute()])).called(1);
    });

    test('when `firebaseFirestoreService.updateCurrentUser` throws an error', () async {
      final dummyError = Exception();
      when(() => firebaseFirestoreService.updateCurrentUser(
            userId: dummyUserId,
            data: {
              FirebaseUserData.keyDeviceIds: [],
              FirebaseUserData.keyDeviceTokens: FieldValue.arrayRemove([dummyDeviceToken]),
            },
          )).thenThrow(dummyError);

      await sharedViewModel.logout();

      verify(() => firebaseFirestoreService.updateCurrentUser(
            userId: dummyUserId,
            data: {
              FirebaseUserData.keyDeviceIds: [],
              FirebaseUserData.keyDeviceTokens: FieldValue.arrayRemove([dummyDeviceToken]),
            },
          )).called(1);
      verifyNever(() => appPreferences.clearCurrentUserData());
      verifyNever(() => firebaseAuthService.signOut());
      verifyNever(() => currentUserStateController.update(any()));
      verify(() => navigator.replaceAll([const LoginRoute()])).called(1);
    });

    test('when `firebaseAuthService.signOut` throws an error', () async {
      final dummyError = Exception();
      when(() => firebaseAuthService.signOut()).thenThrow(dummyError);

      await sharedViewModel.logout();

      verify(() => firebaseFirestoreService.updateCurrentUser(
            userId: dummyUserId,
            data: {
              FirebaseUserData.keyDeviceIds: [],
              FirebaseUserData.keyDeviceTokens: FieldValue.arrayRemove([dummyDeviceToken]),
            },
          )).called(1);
      verify(() => appPreferences.clearCurrentUserData()).called(1);
      verify(() => firebaseAuthService.signOut()).called(1);
      verifyNever(() => currentUserStateController.update(any()));
      verify(() => navigator.replaceAll([const LoginRoute()])).called(1);
    });
  });
}
