import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../index.dart';

@RoutePage()
class MyProfilePage extends BasePage<MyProfileState,
    AutoDisposeStateNotifierProvider<MyProfileViewModel, CommonState<MyProfileState>>> {
  const MyProfilePage({super.key});

  @override
  ScreenViewEvent get screenViewEvent => ScreenViewEvent(screenName: ScreenName.myProfilePage);

  @override
  AutoDisposeStateNotifierProvider<MyProfileViewModel, CommonState<MyProfileState>> get provider =>
      myProfileViewModelProvider;

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    return CommonScaffold(
      body: Container(),
    );
  }
}
