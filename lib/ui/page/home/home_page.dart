// ignore_for_file: missing_common_scrollbar, avoid_hard_coded_colors, avoid_hard_coded_strings
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

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
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.rps, vertical: 12.rps)
            .copyWith(top: MediaQuery.of(context).padding.top),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: 24.rps),
            _buildSpecialBanner(),
            SizedBox(height: 32.rps),
            _buildSubjectSection(),
            SizedBox(height: 32.rps),
            _buildStatsCard(),
            SizedBox(height: 100.rps), // bottom padding for floating glass tab bar
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return HookBuilder(
      builder: (context) {
        final isSearching = useState(false);
        final focusNode = useFocusNode();
        final controller = useTextEditingController();

        useEffect(() {
          void listener() {
            if (!focusNode.hasFocus) {
              isSearching.value = false;
            }
          }

          focusNode.addListener(listener);
          return () => focusNode.removeListener(listener);
        }, [focusNode]);

        if (isSearching.value) {
          return SizedBox(
            height: 44.rps,
            child: GlassSearchBar(
              controller: controller,
              focusNode: focusNode,
              placeholder: 'Tìm kiếm...'.hardcoded,
              showsCancelButton: true,
              useOwnLayer: true,
              cancelButtonColor: color.primary,
              clearIconColor: color.primary,
              searchIconColor: color.primary,
              textStyle: style(color: color.black, fontSize: 16.rps),
              placeholderStyle: style(color: color.greyscale500, fontSize: 16.rps),
              onCancel: () {
                isSearching.value = false;
                controller.clear();
                focusNode.unfocus();
              },
            ),
          );
        }

        return Row(
          children: [
            CommonImage.asset(
              path: image.imageAppIcon,
              width: 32.rps,
              height: 32.rps,
            ),
            SizedBox(width: 8.rps),
            CommonText(
              'UTTQ'.hardcoded,
              style: style(
                color: color.black,
                fontSize: 24.rps,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            Stack(
              children: [
                Icon(
                  AppIcons.notificationLight,
                  size: 28.rps,
                  color: color.greyscale900,
                ),
                Positioned(
                  right: 2.rps,
                  top: 2.rps,
                  child: Container(
                    width: 8.rps,
                    height: 8.rps,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: 16.rps),
            GestureDetector(
              onTap: () {
                isSearching.value = true;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  focusNode.requestFocus();
                });
              },
              child: Icon(
                AppIcons.searchLight,
                size: 28.rps,
                color: color.greyscale900,
              ),
            ),
            SizedBox(width: 16.rps),
            Container(
              width: 36.rps,
              height: 36.rps,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: color.greyscale200, width: 1.5.rps),
              ),
              child: ClipOval(
                child: CommonImage.asset(
                  path: image.imageAppIcon,
                  width: 36.rps,
                  height: 36.rps,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSpecialBanner() {
    return Container(
      width: double.infinity,
      height: 185.rps,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.rps),
        gradient: LinearGradient(
          colors: [color.primary, const Color(0xFF8476EA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Background graphic/illustration (onboarding_2) on the right side
          Positioned(
            right: 0,
            bottom: 0,
            top: 20.rps,
            child: Opacity(
              opacity: 0.9,
              child: CommonImage.asset(
                path: image.onboarding2,
                width: 160.rps,
                height: 160.rps,
                fit: BoxFit.contain,
              ),
            ),
          ),
          // Content on the left side
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.rps, vertical: 20.rps),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonText(
                      'Đặc biệt'.hardcoded,
                      style: style(
                        color: color.white.withValues(alpha: 0.8),
                        fontSize: 14.rps,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.12.rps,
                      ),
                    ),
                    SizedBox(height: 8.rps),
                    SizedBox(
                      width: 200.rps,
                      child: CommonText(
                        'Tham gia các thử thách cùng bạn bè hoặc những người chơi khác.'.hardcoded,
                        style: style(
                          color: color.white,
                          fontSize: 15.rps,
                          fontWeight: FontWeight.w700,
                          height: 1.35,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color.white,
                    foregroundColor: color.primary,
                    padding: EdgeInsets.symmetric(horizontal: 16.rps, vertical: 10.rps),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100.rps),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(AppIcons.profileLight, size: 16.rps),
                      SizedBox(width: 6.rps),
                      CommonText(
                        'Tìm bạn'.hardcoded,
                        style: style(
                          color: color.primary,
                          fontSize: 14.rps,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CommonText(
              'Danh sách môn học'.hardcoded,
              style: style(
                color: color.black,
                fontSize: 18.rps,
                fontWeight: FontWeight.w700,
              ),
            ),
            Row(
              children: [
                CommonText(
                  'Xem thêm'.hardcoded,
                  style: style(
                    color: color.primary,
                    fontSize: 14.rps,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 4.rps),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 12.rps,
                  color: color.primary,
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 16.rps),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          child: Row(
            children: [
              _buildSubjectCard(
                title: 'Xác xuất thống kê'.hardcoded,
                subTitle: '3 tài liệu đã tải'.hardcoded,
                icon: AppIcons.notificationLight,
                bgColor: const Color(0xFFEBF6FF),
                iconColor: const Color(0xFF007AFF),
              ),
              SizedBox(width: 12.rps),
              _buildSubjectCard(
                title: 'Giải tích 1'.hardcoded,
                subTitle: '5 tài liệu đã tải'.hardcoded,
                icon: AppIcons.categoryLight,
                bgColor: const Color(0xFFEEFBF3),
                iconColor: const Color(0xFF34C759),
              ),
              SizedBox(width: 12.rps),
              _buildSubjectCard(
                title: 'Đại số tuyến tính'.hardcoded,
                subTitle: '2 tài liệu đã tải'.hardcoded,
                icon: AppIcons.documentLight,
                bgColor: const Color(0xFFFFEEF0),
                iconColor: const Color(0xFFFF3B30),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSubjectCard({
    required String title,
    required String subTitle,
    required IconData icon,
    required Color bgColor,
    required Color iconColor,
  }) {
    return Container(
      width: 140.rps,
      padding: EdgeInsets.all(16.rps),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16.rps),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 24.rps,
            color: iconColor,
          ),
          SizedBox(height: 12.rps),
          CommonText(
            title,
            style: style(
              color: color.black,
              fontSize: 14.rps,
              fontWeight: FontWeight.w700,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4.rps),
          Row(
            children: [
              Expanded(
                child: CommonText(
                  subTitle,
                  style: style(
                    color: color.greyscale500,
                    fontSize: 12.rps,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 2.rps),
              Icon(
                Icons.arrow_forward_ios,
                size: 8.rps,
                color: color.greyscale500,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.rps),
      decoration: BoxDecoration(
        color: color.primary,
        borderRadius: BorderRadius.circular(24.rps),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CommonText(
                'Thống kê kết quả ôn tập'.hardcoded,
                style: style(
                  color: color.white,
                  fontSize: 18.rps,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Icon(
                AppIcons.plusBold,
                size: 24.rps,
                color: color.white,
              ),
            ],
          ),
          SizedBox(height: 16.rps),
          // Legend Row
          Row(
            children: [
              _buildLegendItem(
                  label: 'Toán rời rạc...'.hardcoded, dotColor: const Color(0xFFFFD2D7)),
              SizedBox(width: 16.rps),
              _buildLegendItem(label: 'C++'.hardcoded, dotColor: const Color(0xFFB8E3FF)),
              SizedBox(width: 16.rps),
              _buildLegendItem(label: 'Triết'.hardcoded, dotColor: const Color(0xFFC7B8FF)),
            ],
          ),
          SizedBox(height: 24.rps),
          // Bar Chart
          SizedBox(
            height: 220.rps,
            child: Stack(
              children: [
                // Horizontal gridlines
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(5, (index) {
                    final label = '${100 - index * 25}%';
                    return Row(
                      children: [
                        SizedBox(
                          width: 36.rps,
                          child: CommonText(
                            label,
                            style: style(
                              color: color.white.withValues(alpha: 0.6),
                              fontSize: 12.rps,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(width: 8.rps),
                        Expanded(
                          child: Container(
                            height: 1.rps,
                            color: color.white.withValues(alpha: 0.15),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
                // The Bars
                Positioned.fill(
                  left: 44.rps,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildBar(
                          score: '3/10'.hardcoded,
                          text: 'Đúng'.hardcoded,
                          percentage: 0.3,
                          barColor: const Color(0xFFFFD2D7)),
                      _buildBar(
                          score: '8/10'.hardcoded,
                          text: 'Đúng'.hardcoded,
                          percentage: 0.8,
                          barColor: const Color(0xFFB8E3FF)),
                      _buildBar(
                          score: '6/10'.hardcoded,
                          text: 'Đúng'.hardcoded,
                          percentage: 0.6,
                          barColor: const Color(0xFFC7B8FF)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem({required String label, required Color dotColor}) {
    return Row(
      children: [
        Container(
          width: 8.rps,
          height: 8.rps,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: dotColor,
          ),
        ),
        SizedBox(width: 6.rps),
        CommonText(
          label,
          style: style(
            color: color.white.withValues(alpha: 0.8),
            fontSize: 12.rps,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildBar({
    required String score,
    required String text,
    required double percentage,
    required Color barColor,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 32.rps,
          height: 140.rps * percentage,
          decoration: BoxDecoration(
            color: barColor,
            borderRadius: BorderRadius.circular(8.rps),
          ),
        ),
        SizedBox(height: 8.rps),
        CommonText(
          score,
          style: style(
            color: color.white,
            fontSize: 12.rps,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 2.rps),
        CommonText(
          text,
          style: style(
            color: color.white.withValues(alpha: 0.6),
            fontSize: 10.rps,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
