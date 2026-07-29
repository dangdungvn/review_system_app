// ignore_for_file: missing_golden_test, missing_common_scrollbar, avoid_hard_coded_colors
import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../index.dart';

@RoutePage()
class SummaryDetailPage extends BasePage<SummaryDetailState,
    AutoDisposeStateNotifierProvider<SummaryDetailViewModel, CommonState<SummaryDetailState>>> {
  const SummaryDetailPage({
    required this.document,
    required this.summaryId,
    super.key,
  });

  final ApiDocumentData document;
  final int summaryId;

  @override
  ScreenViewEvent get screenViewEvent => ScreenViewEvent(screenName: ScreenName.summaryDetailPage);

  @override
  AutoDisposeStateNotifierProvider<SummaryDetailViewModel, CommonState<SummaryDetailState>>
      get provider => summaryDetailViewModelProvider(
          SummaryDetailParams(document: document, summaryId: summaryId));

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    useEffect(() {
      Future.microtask(() => ref.read(provider.notifier).init());
      return null;
    }, const []);

    final state = ref.watch(provider);
    final doc = state.data.document;
    final summary = state.data.summary;
    final isLoading = state.isLoading;

    // Timer logic
    final elapsedSeconds = useState(90); // default to 1:30 matching Figma
    useEffect(() {
      final timer = Timer.periodic(const Duration(seconds: 1), (t) {
        elapsedSeconds.value += 1;
      });
      return timer.cancel;
    }, []);

    final minutes = elapsedSeconds.value ~/ 60;
    final seconds = elapsedSeconds.value % 60;
    final timerStr =
        '${minutes.toString()}${":".hardcoded}${seconds.toString().padLeft(2, "0".hardcoded)}';

    // Scroll progress logic
    final scrollController = useScrollController();
    final scrollProgress = useState(0.36); // default to 36% matching Figma

    useEffect(() {
      void listener() {
        if (!scrollController.hasClients) return;
        final maxScroll = scrollController.position.maxScrollExtent;
        if (maxScroll <= 0) return;
        final progress = scrollController.offset / maxScroll;
        scrollProgress.value = progress.clamp(0.0, 1.0);
      }

      scrollController.addListener(listener);
      return () => scrollController.removeListener(listener);
    }, []);

    return CommonScaffold(
      shimmerEnabled: isLoading && summary == null,
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.rps),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: color.black),
                    onPressed: () => context.router.back(),
                  ),
                  SizedBox(width: 8.rps),
                  Expanded(
                    child: CommonText(
                      doc.title,
                      style: style(
                        color: color.black,
                        fontSize: 20.rps,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.rps),

            // Lilac card container filling the remaining screen
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 24.rps, right: 24.rps, bottom: 24.rps),
                padding: EdgeInsets.all(24.rps),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F1FF),
                  borderRadius: BorderRadius.circular(32.rps),
                ),
                child: Column(
                  children: [
                    // Card header: Title and Timer
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CommonText(
                          'Ôn tập tóm tắt'.hardcoded,
                          style: style(
                            color: const Color(0xFF6A5AE0),
                            fontSize: 18.rps,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.rps, vertical: 6.rps),
                          decoration: BoxDecoration(
                            color: color.white,
                            borderRadius: BorderRadius.circular(16.rps),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.access_time, size: 14.rps, color: color.greyscale500),
                              SizedBox(width: 4.rps),
                              CommonText(
                                timerStr,
                                style: style(
                                  color: color.greyscale500,
                                  fontSize: 12.rps,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.rps),

                    // Progress bar row
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 6.rps,
                            decoration: BoxDecoration(
                              color: color.white,
                              borderRadius: BorderRadius.circular(3.rps),
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: scrollProgress.value,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFF6A5AE0),
                                  borderRadius: BorderRadius.circular(3.rps),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12.rps),
                        CommonText(
                          '${(scrollProgress.value * 100).toInt()}${"%".hardcoded}',
                          style: style(
                            color: const Color(0xFFFF8F6B),
                            fontSize: 14.rps,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.rps),

                    // Scrollable summary contents
                    Expanded(
                      child: Scrollbar(
                        controller: scrollController,
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child:
                              summary == null ? _buildEmptyState() : _buildSummaryContent(summary),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryContent(ApiSummaryData summary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        CommonText(
          summary.title,
          style: style(
            color: const Color(0xFF1F1135),
            fontSize: 18.rps,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: 12.rps),

        // Overview
        if (summary.overview.isNotEmpty) ...[
          CommonText(
            summary.overview,
            style: style(
              color: const Color(0xFF534C5F),
              fontSize: 14.rps,
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 24.rps),
        ],

        // Key Points
        if (summary.keyPoints.isNotEmpty) ...[
          CommonText(
            'Điểm mấu chốt'.hardcoded,
            style: style(
              color: const Color(0xFF1F1135),
              fontSize: 16.rps,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 12.rps),
          ...summary.keyPoints.map((point) => Padding(
                padding: EdgeInsets.only(bottom: 8.rps),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 6.rps, right: 8.rps),
                      child: Container(
                        width: 6.rps,
                        height: 6.rps,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF6A5AE0),
                        ),
                      ),
                    ),
                    Expanded(
                      child: CommonText(
                        point,
                        style: style(
                          color: const Color(0xFF534C5F),
                          fontSize: 14.rps,
                          height: 1.4,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
          SizedBox(height: 24.rps),
        ],

        // Sections
        if (summary.sections.isNotEmpty) ...[
          ...summary.sections.map((section) => Padding(
                padding: EdgeInsets.only(bottom: 24.rps),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonText(
                      section.heading,
                      style: style(
                        color: const Color(0xFF1F1135),
                        fontSize: 16.rps,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 8.rps),
                    CommonText(
                      section.content,
                      style: style(
                        color: const Color(0xFF534C5F),
                        fontSize: 14.rps,
                        height: 1.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )),
        ],

        // Suggested Questions
        if (summary.suggestedQuestions.isNotEmpty) ...[
          CommonText(
            'Câu hỏi gợi ý'.hardcoded,
            style: style(
              color: const Color(0xFF1F1135),
              fontSize: 16.rps,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 12.rps),
          ...summary.suggestedQuestions.map((q) => Padding(
                padding: EdgeInsets.only(bottom: 12.rps),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.help_outline,
                      size: 16.rps,
                      color: const Color(0xFF6A5AE0),
                    ),
                    SizedBox(width: 8.rps),
                    Expanded(
                      child: CommonText(
                        q,
                        style: style(
                          color: const Color(0xFF534C5F),
                          fontSize: 14.rps,
                          height: 1.4,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 40.rps),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(Icons.description_outlined, size: 48.rps, color: color.greyscale300),
          SizedBox(height: 12.rps),
          CommonText(
            'Không tìm thấy tóm tắt nào'.hardcoded,
            style: style(
              color: color.greyscale500,
              fontSize: 14.rps,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
