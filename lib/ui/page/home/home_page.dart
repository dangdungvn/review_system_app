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
    useEffect(() {
      Future.microtask(() => ref.read(provider.notifier).init());
      return null;
    }, const []);

    final documents = ref.watch(provider.select((s) => s.data.documents));
    final activities = ref.watch(provider.select((s) => s.data.activities));
    final isLoading = ref.watch(provider.select((s) => s.isLoading));

    return CommonScaffold(
      shimmerEnabled: isLoading && documents.isEmpty,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.rps, vertical: 12.rps),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSpecialBanner(),
            SizedBox(height: 32.rps),
            _buildSubjectSection(
              context: context,
              ref: ref,
              documents: documents,
            ),
            SizedBox(height: 32.rps),
            _buildStatsCard(activities),
            SizedBox(height: 100.rps), // bottom padding for floating glass tab bar
          ],
        ),
      ),
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

  Widget _buildSubjectSection({
    required BuildContext context,
    required WidgetRef ref,
    required List<ApiDocumentData> documents,
  }) {
    final displayDocs = documents.isNotEmpty
        ? documents
        : const [
            ApiDocumentData(title: 'Xác xuất thống kê', description: '3 tài liệu đã tải'),
            ApiDocumentData(title: 'Giải tích 1', description: '5 tài liệu đã tải'),
            ApiDocumentData(title: 'Đại số tuyến tính', description: '2 tài liệu đã tải'),
          ];

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
            children: List.generate(displayDocs.length, (index) {
              final doc = displayDocs[index];
              final colors = [
                const Color(0xFFEBF6FF),
                const Color(0xFFEEFBF3),
                const Color(0xFFFFEEF0),
              ];
              final iconColors = [
                const Color(0xFF007AFF),
                const Color(0xFF34C759),
                const Color(0xFFFF3B30),
              ];
              final icons = [
                AppIcons.notificationLight,
                AppIcons.categoryLight,
                AppIcons.documentLight,
              ];
              final colorIdx = index % colors.length;

              return Padding(
                padding: EdgeInsets.only(right: index == displayDocs.length - 1 ? 0 : 12.rps),
                child: CommonInkWell(
                  onTap: () {
                    if (doc.id > 0) {
                      context.router.push(SubjectDetailRoute(document: doc));
                    }
                  },
                  child: _buildSubjectCard(
                    title: doc.title,
                    subTitle:
                        doc.description ?? '${(doc.fileSize / 1024 / 1024).toStringAsFixed(1)} MB',
                    icon: icons[colorIdx],
                    bgColor: colors[colorIdx],
                    iconColor: iconColors[colorIdx],
                  ),
                ),
              );
            }),
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

  Widget _buildStatsCard(List<ApiReviewActivityData> activities) {
    final displayActs = activities.isNotEmpty
        ? activities.take(3).toList()
        : const [
            ApiReviewActivityData(
                subjectTitle: 'Toán rời rạc', score: 30, correctCount: 3, totalItems: 10),
            ApiReviewActivityData(subjectTitle: 'C++', score: 80, correctCount: 8, totalItems: 10),
            ApiReviewActivityData(
                subjectTitle: 'Triết', score: 60, correctCount: 6, totalItems: 10),
          ];

    final colors = [
      const Color(0xFFFFD2D7),
      const Color(0xFFB8E3FF),
      const Color(0xFFC7B8FF),
    ];

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
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(displayActs.length, (index) {
                final act = displayActs[index];
                return Padding(
                  padding: EdgeInsets.only(right: 16.rps),
                  child: _buildLegendItem(
                    label: act.documentTitle ?? 'Môn học',
                    dotColor: colors[index % colors.length],
                  ),
                );
              }),
            ),
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
                    children: List.generate(displayActs.length, (index) {
                      final act = displayActs[index];
                      final pct = act.accuracy > 1.0 ? act.accuracy / 100.0 : act.accuracy;
                      return _buildBar(
                        score: '${act.correctAnswers}/${act.totalQuestions}',
                        text: 'Đúng'.hardcoded,
                        percentage: pct.clamp(0.0, 1.0),
                        barColor: colors[index % colors.length],
                      );
                    }),
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
