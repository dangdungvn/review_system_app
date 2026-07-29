// ignore_for_file: missing_golden_test, missing_common_scrollbar
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../index.dart';

@RoutePage()
class ReviewMethodPage extends BasePage<ReviewMethodState,
    AutoDisposeStateNotifierProvider<ReviewMethodViewModel, CommonState<ReviewMethodState>>> {
  const ReviewMethodPage({
    required this.document,
    super.key,
  });

  final ApiDocumentData document;

  @override
  ScreenViewEvent get screenViewEvent => ScreenViewEvent(screenName: ScreenName.reviewMethodPage);

  @override
  AutoDisposeStateNotifierProvider<ReviewMethodViewModel, CommonState<ReviewMethodState>>
      get provider => reviewMethodViewModelProvider(document);

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    useEffect(() {
      Future.microtask(() => ref.read(provider.notifier).init());
      return null;
    }, const []);

    final state = ref.watch(provider);
    final doc = state.data.document;

    return CommonScaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            elevation: 0,
            backgroundColor: color.white,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: color.black),
              onPressed: () => context.router.back(),
            ),
            title: CommonText(
              doc.title,
              style: style(
                color: color.black,
                fontSize: 20.rps,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 24.rps, vertical: 12.rps),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Align(
                  alignment: Alignment.centerLeft,
                  child: CommonText(
                    'Lựa chọn phương pháp'.hardcoded,
                    style: style(
                      color: const Color(0xFF6A5AE0),
                      fontSize: 22.rps,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                SizedBox(height: 24.rps),

                // Card 1: Tóm tắt
                _buildMethodCard(
                  title: 'Tóm tắt'.hardcoded,
                  description: 'Xem nội dung trọng tâm và ghi chú rút gọn'.hardcoded,
                  imagePath: Assets.images.summary,
                  bgColor: const Color(0xFFF3F1FF),
                  buttonText: 'Bắt đầu'.hardcoded,
                  buttonBgColor: color.white,
                  buttonTextColor: const Color(0xFF1F1135),
                  onTap: () {
                    final summaryId =
                        state.data.summaries.isNotEmpty ? state.data.summaries.first.id : 0;
                    print('🚀 [REVIEW_METHOD] Summary ID: $summaryId'.hardcoded);
                    context.router.push(SummaryDetailRoute(document: doc, summaryId: summaryId));
                  },
                ),

                // Card 2: Trắc nghiệm
                _buildMethodCard(
                  title: 'Trắc nghiệm'.hardcoded,
                  description: 'Chọn một trong 4 đáp án đúng nhất'.hardcoded,
                  imagePath: Assets.images.quiz,
                  bgColor: const Color(0xFF8B7FF7),
                  titleColor: color.white,
                  descriptionColor: color.white.withOpacity(0.8),
                  buttonText: 'Thử thách'.hardcoded,
                  buttonBgColor: color.white,
                  buttonTextColor: const Color(0xFF8B7FF7),
                  onTap: () {},
                ),

                // Card 3: Flashcard
                _buildMethodCard(
                  title: 'Flashcard'.hardcoded,
                  description: 'Quét trái khi sai, quét phải khi đúng'.hardcoded,
                  imagePath: Assets.images.flashcard,
                  bgColor: const Color(0xFFD1ECFF),
                  buttonText: 'Luyện tập'.hardcoded,
                  buttonBgColor: const Color(0xFF6A5AE0),
                  buttonTextColor: color.white,
                  onTap: () {},
                ),

                SizedBox(height: 100.rps),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMethodCard({
    required String title,
    required String description,
    required String imagePath,
    required Color bgColor,
    required String buttonText,
    required Color buttonBgColor,
    required Color buttonTextColor,
    required VoidCallback onTap,
    Color? titleColor,
    Color? descriptionColor,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 24.rps),
      padding: EdgeInsets.symmetric(horizontal: 24.rps, vertical: 20.rps),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(32.rps),
      ),
      child: Column(
        children: [
          CommonText(
            title,
            style: style(
              color: titleColor ?? const Color(0xFF1F1135),
              fontSize: 20.rps,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 6.rps),
          CommonText(
            description,
            style: style(
              color: descriptionColor ?? const Color(0xFF7D7787),
              fontSize: 12.rps,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.rps),
          CommonImage.asset(
            path: imagePath,
            height: 160.rps,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 16.rps),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CommonInkWell(
                onTap: onTap,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24.rps, vertical: 10.rps),
                  decoration: BoxDecoration(
                    color: buttonBgColor,
                    borderRadius: BorderRadius.circular(20.rps),
                  ),
                  child: CommonText(
                    buttonText,
                    style: style(
                      color: buttonTextColor,
                      fontSize: 14.rps,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
