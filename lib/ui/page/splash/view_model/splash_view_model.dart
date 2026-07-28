import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../index.dart';

final splashViewModelProvider =
    StateNotifierProvider.autoDispose<SplashViewModel, CommonState<SplashState>>(
  (ref) => SplashViewModel(ref),
);

class SplashViewModel extends BaseViewModel<SplashState> {
  SplashViewModel(this.ref) : super(const CommonState(data: SplashState()));

  final Ref ref;

  Future<void> init() async {
    await runCatching(
      action: () async {
        FlutterNativeSplash.remove();
        final token = await ref.appPreferences.accessToken;
        final refreshToken = await ref.appPreferences.refreshToken;
        print('🚀 [STARTUP] Access Token: $token'.hardcoded);
        print('🚀 [STARTUP] Refresh Token: $refreshToken'.hardcoded);
        if (ref.appPreferences.isLoggedIn && token.isNotEmpty) {
          await ref.nav.replaceAll([const MainRoute()]);
        } else {
          try {
            await ref.sharedViewModel.forceLogout();
          } catch (e) {
            Log.e('force logout on splash error: $e'.hardcoded);
          }
          if (Env.flavor != Flavor.develop && ref.appPreferences.hasSeenOnboarding) {
            await ref.nav.replaceAll([const LoginRoute()]);
          } else {
            await ref.nav.replaceAll([const OnboardingRoute()]);
          }
        }
      },
    );
  }
}
