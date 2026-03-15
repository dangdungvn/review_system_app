import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../index.dart';

@RoutePage()
class HomePage extends BasePage<HomeState,
    AutoDisposeStateNotifierProvider<HomeViewModel, CommonState<HomeState>>> {
  const HomePage({super.key});

  @override
  ScreenViewEvent get screenViewEvent => ScreenViewEvent(screenName: ScreenName.homePage);

  @override
  AutoDisposeStateNotifierProvider<HomeViewModel, CommonState<HomeState>> get provider =>
      homeViewModelProvider;

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    return CommonScaffold(
      body: Container(),
    );
  }
}
