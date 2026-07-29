// ignore_for_file: avoid_hard_coded_strings, missing_common_scrollbar, avoid_hard_coded_colors, missing_golden_test
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../index.dart';

@RoutePage()
class SubjectDetailPage extends BasePage<SubjectDetailState,
    AutoDisposeStateNotifierProvider<SubjectDetailViewModel, CommonState<SubjectDetailState>>> {
  const SubjectDetailPage({
    required this.document,
    super.key,
  });

  final ApiDocumentData document;

  @override
  ScreenViewEvent get screenViewEvent => ScreenViewEvent(
      screenName: ScreenName.subjectDetailPage); // use subject detail page analytic context

  @override
  AutoDisposeStateNotifierProvider<SubjectDetailViewModel, CommonState<SubjectDetailState>>
      get provider => subjectDetailViewModelProvider(document);

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    useEffect(() {
      Future.microtask(() => ref.read(provider.notifier).init());
      return null;
    }, const []);

    final state = ref.watch(provider);
    final activities = state.data.activities;
    final isLoading = state.isLoading;

    // Group activities by exerciseId to show unique exercises
    final latestExercises = <String, ApiReviewActivityData>{};
    for (final act in activities) {
      if (act.exerciseId.isEmpty) continue;
      final existing = latestExercises[act.exerciseId];
      if (existing == null) {
        latestExercises[act.exerciseId] = act;
      } else {
        final dateNew =
            DateTime.tryParse(act.completedAt.isNotEmpty ? act.completedAt : act.startedAt) ??
                DateTime(1970);
        final dateExisting = DateTime.tryParse(
                existing.completedAt.isNotEmpty ? existing.completedAt : existing.startedAt) ??
            DateTime(1970);
        if (dateNew.isAfter(dateExisting)) {
          latestExercises[act.exerciseId] = act;
        }
      }
    }

    final exercises = latestExercises.values.toList()
      ..sort((a, b) {
        final dateA = DateTime.tryParse(a.completedAt.isNotEmpty ? a.completedAt : a.startedAt) ??
            DateTime(1970);
        final dateB = DateTime.tryParse(b.completedAt.isNotEmpty ? b.completedAt : b.startedAt) ??
            DateTime(1970);
        return dateB.compareTo(dateA);
      });

    // Stats calculations
    final completedCount = exercises.where((e) => e.progress == 100).length;
    final pendingCount = exercises.where((e) => e.progress < 100).length;

    final subjectCode = 'MAT${document.id.toString().padLeft(3, '0')}';

    return CommonScaffold(
      shimmerEnabled: isLoading && exercises.isEmpty,
      body: CustomScrollView(
        slivers: [
          // Custom App Bar matching Figma
          SliverAppBar(
            pinned: true,
            elevation: 0,
            backgroundColor: color.white,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: color.black),
              onPressed: () => context.router.back(),
            ),
            title: CommonText(
              document.title,
              style: style(
                color: color.black,
                fontSize: 20.rps,
                fontWeight: FontWeight.w700,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.more_horiz, color: color.black),
                onPressed: () {},
              ),
              SizedBox(width: 8.rps),
            ],
          ),

          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 24.rps, vertical: 12.rps),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Purple Stats Card
                _buildStatsCard(
                  completed: completedCount,
                  pending: pendingCount,
                  code: subjectCode,
                ),
                SizedBox(height: 16.rps),

                // Description Text
                if (document.description != null && document.description!.isNotEmpty) ...[
                  CommonText(
                    document.description!,
                    style: style(
                      color: color.greyscale500,
                      fontSize: 14.rps,
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 24.rps),
                ],

                // "Danh sách bài tập" Section Title
                CommonText(
                  'Danh sách bài tập'.hardcoded,
                  style: style(
                    color: color.black,
                    fontSize: 18.rps,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 16.rps),

                // List of Exercises
                if (exercises.isEmpty && !isLoading)
                  _buildEmptyState()
                else
                  ...List.generate(
                    exercises.length,
                    (index) {
                      final exercise = exercises[index];
                      final progress = exercise.progress / 100.0;
                      final dateString = _formatActivityDate(
                        exercise.completedAt.isNotEmpty ? exercise.completedAt : exercise.startedAt,
                      );

                      final docId = int.tryParse(exercise.documentId) ??
                          int.tryParse(exercise.exerciseId) ??
                          0;
                      final exerciseDoc = ApiDocumentData(
                        id: docId,
                        title: exercise.exerciseTitle.isNotEmpty
                            ? exercise.exerciseTitle
                            : 'Bài tập'.hardcoded,
                      );

                      return Padding(
                        padding: EdgeInsets.only(bottom: 12.rps),
                        child: CommonInkWell(
                          onTap: () {
                            context.router.push(ReviewMethodRoute(document: exerciseDoc));
                          },
                          child: _buildExerciseCard(
                            title: exercise.exerciseTitle.isNotEmpty
                                ? exercise.exerciseTitle
                                : 'Bài tập'.hardcoded,
                            progress: progress,
                            dateString: dateString,
                          ),
                        ),
                      );
                    },
                  ),
                SizedBox(height: 100.rps), // Bottom space
              ]),
            ),
          ),
        ],
      ),
    );
  }

  String _formatActivityDate(String startedAt) {
    final parsed = DateTime.tryParse(startedAt);
    if (parsed == null) return startedAt;
    final local = parsed.toLocal();
    final today = DateTimeUtil.today;
    final diffDays = DateTimeUtil.daysBetween(from: local.withTimeAtStartOfDay(), to: today);
    if (diffDays == 0) {
      return 'Hôm nay'.hardcoded;
    } else if (diffDays == 1) {
      return 'Hôm qua'.hardcoded;
    } else {
      return DateFormat('d/M/yyyy').format(local);
    }
  }

  Widget _buildStatsCard({
    required int completed,
    required int pending,
    required String code,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 20.rps, horizontal: 16.rps),
      decoration: BoxDecoration(
        color: const Color(0xFF6A5AE0),
        borderRadius: BorderRadius.circular(24.rps),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatColumn(
            icon: Icons.star_border_rounded,
            label: 'HOÀN THÀNH'.hardcoded,
            value: completed.toString(),
          ),
          Container(height: 40.rps, width: 1.rps, color: Colors.white.withOpacity(0.2)),
          _buildStatColumn(
            icon: Icons.language_rounded,
            label: 'CHƯA XONG'.hardcoded,
            value: pending.toString(),
          ),
          Container(height: 40.rps, width: 1.rps, color: Colors.white.withOpacity(0.2)),
          _buildStatColumn(
            icon: Icons.gps_not_fixed_rounded,
            label: 'MÃ MÔN'.hardcoded,
            value: code,
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24.rps),
        SizedBox(height: 8.rps),
        CommonText(
          label,
          style: style(
            color: Colors.white.withOpacity(0.7),
            fontSize: 10.rps,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
          ),
        ),
        SizedBox(height: 4.rps),
        CommonText(
          value,
          style: style(
            color: Colors.white,
            fontSize: 16.rps,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  (Color, Color, Color) _getExerciseCardColors(double progress) {
    if (progress >= 1.0) {
      return (
        const Color(0xFFEEFBF3),
        const Color(0xFF34C759).withOpacity(0.2),
        const Color(0xFF34C759),
      );
    }
    if (progress <= 0.0) {
      return (
        const Color(0xFFF9F9FB),
        const Color(0xFFE5E5EA),
        const Color(0xFFE5E5EA),
      );
    }
    if (progress < 0.5) {
      return (
        const Color(0xFFFFEEF0),
        const Color(0xFFFF3B30).withOpacity(0.2),
        const Color(0xFFFF3B30),
      );
    }
    return (
      const Color(0xFFFFF9E6),
      const Color(0xFFFF9500).withOpacity(0.2),
      const Color(0xFFFF9500),
    );
  }

  Widget _buildExerciseCard({
    required String title,
    required double progress,
    required String dateString,
  }) {
    // Styling colors based on progress percentage
    final (bgColor, borderColor, barColor) = _getExerciseCardColors(progress);

    return Container(
      padding: EdgeInsets.all(16.rps),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16.rps),
        border: Border.all(color: borderColor, width: 1.5.rps),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: CommonText(
                  title,
                  style: style(
                    color: color.black,
                    fontSize: 16.rps,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 8.rps),
              CommonText(
                '${(progress * 100).toInt()}%',
                style: style(
                  color: progress > 0 ? barColor : color.greyscale500,
                  fontSize: 14.rps,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.rps),
          // Progress bar
          Container(
            width: double.infinity,
            height: 6.rps,
            decoration: BoxDecoration(
              color: color.white,
              borderRadius: BorderRadius.circular(3.rps),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress.clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  color: barColor,
                  borderRadius: BorderRadius.circular(3.rps),
                ),
              ),
            ),
          ),
          SizedBox(height: 12.rps),
          Row(
            children: [
              Icon(Icons.access_time, size: 14.rps, color: color.greyscale500),
              SizedBox(width: 6.rps),
              CommonText(
                dateString,
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
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 40.rps),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(Icons.assignment_outlined, size: 48.rps, color: color.greyscale300),
          SizedBox(height: 12.rps),
          CommonText(
            'Chưa có bài tập nào'.hardcoded,
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

class _MockExercise {
  _MockExercise({
    required this.title,
    required this.progress,
    required this.date,
  });
  final String title;
  final double progress;
  final String date;
}
