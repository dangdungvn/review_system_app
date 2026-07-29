// ignore_for_file: incorrect_parent_class, missing_golden_test, avoid_hard_coded_strings, missing_common_scrollbar, avoid_hard_coded_colors
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../index.dart';

@RoutePage()
class ReviewPage extends BasePage<ReviewState,
    AutoDisposeStateNotifierProvider<ReviewViewModel, CommonState<ReviewState>>> {
  const ReviewPage({super.key});

  @override
  ScreenViewEvent get screenViewEvent => ScreenViewEvent(screenName: ScreenName.reviewPage);

  @override
  AutoDisposeStateNotifierProvider<ReviewViewModel, CommonState<ReviewState>> get provider =>
      reviewViewModelProvider;

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    useEffect(() {
      Future.microtask(() => ref.read(provider.notifier).init());
      return null;
    }, const []);

    final documents = ref.watch(provider.select((s) => s.data.documents));
    final recommendations = ref.watch(provider.select((s) => s.data.recommendations));
    final isLoading = ref.watch(provider.select((s) => s.isLoading));

    return CommonScaffold(
      shimmerEnabled: isLoading && documents.isEmpty,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.rps, vertical: 12.rps),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSubjectSection(documents),
            SizedBox(height: 32.rps),
            _buildRecentReviewSection(recommendations),
            SizedBox(height: 100.rps), // bottom padding for floating glass tab bar
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectSection(List<ApiDocumentData> documents) {
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
                child: _buildSubjectCard(
                  title: doc.title,
                  subTitle:
                      doc.description ?? '${(doc.fileSize / 1024 / 1024).toStringAsFixed(1)} MB',
                  icon: icons[colorIdx],
                  bgColor: colors[colorIdx],
                  iconColor: iconColors[colorIdx],
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
          CommonText(
            subTitle,
            style: style(
              color: color.greyscale500,
              fontSize: 12.rps,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildRecentReviewSection(List<ApiRecommendationData> recommendations) {
    final displayRecs = recommendations.isNotEmpty
        ? recommendations
        : const [
            ApiRecommendationData(title: 'Xác xuất thống kê', reason: 'Hôm nay', type: 'exam'),
            ApiRecommendationData(title: 'Toán rời rạc', reason: 'Hôm qua', type: 'flashcard'),
            ApiRecommendationData(
                title: 'Xác xuất thống kê ds...', reason: '19/1/2025', type: 'true_false'),
            ApiRecommendationData(title: 'Giải tích 1', reason: '18/1/2025', type: 'exam'),
          ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CommonText(
              'Đã ôn tập gần đây'.hardcoded,
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
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: displayRecs.length,
          separatorBuilder: (context, index) => SizedBox(height: 12.rps),
          itemBuilder: (context, index) {
            final item = displayRecs[index];
            final type = item.type;

            final iconColor = switch (type) {
              'exam' => const Color(0xFF007AFF),
              'flashcard' => const Color(0xFF34C759),
              'true_false' => const Color(0xFFFF9500),
              _ => const Color(0xFFAF52DE),
            };

            final bgColor = switch (type) {
              'exam' => const Color(0xFFEBF6FF),
              'flashcard' => const Color(0xFFEEFBF3),
              'true_false' => const Color(0xFFFFF9E6),
              _ => const Color(0xFFFBF4FF),
            };

            return Container(
              padding: EdgeInsets.all(12.rps),
              decoration: BoxDecoration(
                color: color.white,
                borderRadius: BorderRadius.circular(16.rps),
                border: Border.all(color: color.greyscale200),
                boxShadow: [
                  BoxShadow(
                    color: color.black.withOpacity(0.02),
                    blurRadius: 10.rps,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 48.rps,
                    height: 48.rps,
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(12.rps),
                    ),
                    child: Icon(
                      AppIcons.documentLight,
                      color: iconColor,
                      size: 24.rps,
                    ),
                  ),
                  SizedBox(width: 12.rps),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonText(
                          item.title.hardcoded,
                          style: style(
                            color: color.black,
                            fontSize: 16.rps,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.rps),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time_rounded,
                              size: 14.rps,
                              color: color.greyscale500,
                            ),
                            SizedBox(width: 4.rps),
                            CommonText(
                              item.reason.hardcoded,
                              style: style(
                                color: color.greyscale500,
                                fontSize: 12.rps,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.play_circle_fill,
                      color: color.primary,
                      size: 32.rps,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
