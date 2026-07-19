import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import '../../../../index.dart';

enum BottomTab {
  home(
    icon: Icon(AppIcons.homeLight),
    activeIcon: Icon(AppIcons.homeBold),
  ),
  review(
    icon: Icon(AppIcons.documentLight),
    activeIcon: Icon(AppIcons.documentBold),
  ),
  statistics(
    icon: Icon(AppIcons.chartLight),
    activeIcon: Icon(AppIcons.chartBold),
  ),
  myProfile(
    icon: Icon(AppIcons.profileLight),
    activeIcon: Icon(AppIcons.profileBold),
  );

  const BottomTab({
    required this.icon,
    required this.activeIcon,
  });
  final Icon icon;
  final Icon activeIcon;

  String get title {
    switch (this) {
      case BottomTab.home:
        return l10n.home;
      case BottomTab.review:
        return l10n.tabReview;
      case BottomTab.statistics:
        return l10n.tabStatistics;
      case BottomTab.myProfile:
        return l10n.tabAccount;
    }
  }
}

@RoutePage()
class MainPage extends BasePage<MainState,
    AutoDisposeStateNotifierProvider<MainViewModel, CommonState<MainState>>> {
  const MainPage({super.key});

  @override
  ScreenViewEvent get screenViewEvent => ScreenViewEvent(screenName: ScreenName.mainPage);

  @override
  AutoDisposeStateNotifierProvider<MainViewModel, CommonState<MainState>> get provider =>
      mainViewModelProvider;

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    useEffect(
      () {
        Future.microtask(() {
          ref.read(provider.notifier).init();
        });

        return () {};
      },
      [],
    );

    return AutoTabsScaffold(
      routes: ref.read(appNavigatorProvider).tabRoutes,
      extendBody: true,
      bottomNavigationBuilder: (_, tabsRouter) {
        ref.read(appNavigatorProvider).tabsRouter = tabsRouter;

        return GlassTabBar.bottom(
          selectedIndex: tabsRouter.activeIndex,
          onTabSelected: (index) {
            if (index == tabsRouter.activeIndex) {
              ref.read(appNavigatorProvider).popUntilRootOfCurrentBottomTab();
            }
            tabsRouter.setActiveIndex(index);
          },
          selectedIconColor: color.primary,
          // unselectedIconColor: color.greyscale500,
          selectedLabelColor: color.black,
          // unselectedLabelColor: color.greyscale500,
          tabs: BottomTab.values
              .map(
                (tab) => GlassTab(
                  // label: tab.title,
                  icon: tab.icon,
                  activeIcon: tab.activeIcon,
                ),
              )
              .toList(),
        );
      },
    );
  }
}
