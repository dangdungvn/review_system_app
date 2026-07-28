// ignore_for_file: incorrect_parent_class, missing_golden_test, avoid_hard_coded_strings, missing_common_scrollbar, avoid_hard_coded_colors
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../index.dart';

@RoutePage()
class StatisticsPage extends BasePage<StatisticsState,
    AutoDisposeStateNotifierProvider<StatisticsViewModel, CommonState<StatisticsState>>> {
  const StatisticsPage({super.key});

  @override
  ScreenViewEvent get screenViewEvent => ScreenViewEvent(screenName: ScreenName.statisticsPage);

  @override
  AutoDisposeStateNotifierProvider<StatisticsViewModel, CommonState<StatisticsState>> get provider =>
      statisticsViewModelProvider;

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    useEffect(() {
      Future.microtask(() => ref.read(provider.notifier).init());
      return null;
    }, const []);

    final progress = ref.watch(provider.select((s) => s.data.progress));
    final activities = ref.watch(provider.select((s) => s.data.activities));
    final isLoading = ref.watch(provider.select((s) => s.isLoading));

    final currentTab = useState(0);

    return CommonScaffold(
      shimmerEnabled: isLoading && activities.isEmpty,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.rps, vertical: 12.rps),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTabs(currentTab),
            SizedBox(height: 24.rps),
            if (currentTab.value == 0) ...[
              _buildResultsTabContent(progress: progress, activities: activities),
            ] else if (currentTab.value == 1) ...[
              _buildSubjectsTabContent(progress: progress, activities: activities),
            ] else ...[
              _buildTimeTabContent(activities),
            ],
            SizedBox(height: 100.rps), // bottom padding for floating glass tab bar
          ],
        ),
      ),
    );
  }

  Widget _buildTabs(ValueNotifier<int> currentTab) {
    final tabLabels = ['Kết quả', 'Môn học', 'Thời gian'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(tabLabels.length, (index) {
        final isSelected = currentTab.value == index;
        return GestureDetector(
          onTap: () => currentTab.value = index,
          child: Column(
            children: [
              CommonText(
                tabLabels[index].hardcoded,
                style: style(
                  color: isSelected ? color.primary : color.greyscale500,
                  fontSize: 16.rps,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
              SizedBox(height: 4.rps),
              Container(
                width: 6.rps,
                height: 6.rps,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? color.primary : Colors.transparent,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  double _getWeekAccuracy({
    required List<ApiReviewActivityData> activities,
    required int weekIndex,
  }) {
    if (activities.isEmpty) {
      return weekIndex == 0 ? 0.3 : (weekIndex == 1 ? 0.8 : 0.55);
    }
    final partitionSize = (activities.length / 3).ceil();
    final startIndex = weekIndex * partitionSize;
    if (startIndex >= activities.length) return 0.5;
    final endIndex = (startIndex + partitionSize).clamp(0, activities.length);
    final subList = activities.sublist(startIndex, endIndex);
    if (subList.isEmpty) return 0.5;
    final totalAccuracy = subList.map((e) => e.accuracy).reduce((a, b) => a + b);
    return (totalAccuracy / subList.length) / 100;
  }

  Widget _buildResultsTabContent({
    required ApiUserProgressData progress,
    required List<ApiReviewActivityData> activities,
  }) {
    final list = activities.isNotEmpty
        ? activities
        : const [
            ApiReviewActivityData(documentTitle: 'Xác suất thống kê', accuracy: 80, correctAnswers: 8, totalQuestions: 10),
            ApiReviewActivityData(documentTitle: 'Toán rời rạc', accuracy: 60, correctAnswers: 6, totalQuestions: 10),
          ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonText(
          'Thống kê kết quả ôn tập'.hardcoded,
          style: style(
            color: color.black,
            fontSize: 18.rps,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 16.rps),
        _buildChartCard(activities),
        SizedBox(height: 24.rps),
        ...List.generate(list.length, (index) {
          final item = list[index];
          final colors = [const Color(0xFF007AFF), const Color(0xFF34C759)];
          return Padding(
            padding: EdgeInsets.only(bottom: index == list.length - 1 ? 0 : 12.rps),
            child: _buildSubjectStatusCard(
              title: item.documentTitle ?? 'Môn học',
              completion: '${item.accuracy.toInt()}%',
              correctCount: item.correctAnswers,
              incorrectCount: item.totalQuestions - item.correctAnswers,
              statusColor: colors[index % colors.length],
            ),
          );
        }),
      ],
    );
  }

  Map<String, double> _getSubjectDistribution(List<ApiReviewActivityData> activities) {
    if (activities.isEmpty) {
      return {'Toán': 0.4, 'Vật lý': 0.23, 'Hóa học': 0.2, 'Khác': 0.17};
    }
    final counts = <String, int>{};
    for (final act in activities) {
      final title = act.documentTitle ?? 'Khác';
      counts[title] = (counts[title] ?? 0) + 1;
    }
    final total = activities.length;
    return counts.map((key, value) => MapEntry(key, value / total));
  }

  Widget _buildSubjectsTabContent({
    required ApiUserProgressData progress,
    required List<ApiReviewActivityData> activities,
  }) {
    final distribution = _getSubjectDistribution(activities);
    final keys = distribution.keys.toList();
    
    final progressItems = activities.isNotEmpty
        ? keys.map((subject) {
            final subActs = activities.where((e) => (e.documentTitle ?? 'Khác') == subject).toList();
            final avgAccuracy = subActs.map((e) => e.accuracy).reduce((a, b) => a + b) / subActs.length;
            final totalTimeSeconds = subActs.map((e) => e.timeSpent).reduce((a, b) => a + b);
            final hours = totalTimeSeconds ~/ 3600;
            final mins = (totalTimeSeconds % 3600) ~/ 60;
            return _SubjectProgressItem(
              title: subject,
              percent: avgAccuracy / 100,
              time: hours > 0 ? '${hours}h${mins}m' : '${mins}m',
            );
          }).toList()
        : const [
            _SubjectProgressItem(title: 'Toán', percent: 0.36, time: '5h30m'),
            _SubjectProgressItem(title: 'Vật lý', percent: 0.36, time: '5h30m'),
            _SubjectProgressItem(title: 'Hóa học', percent: 0.28, time: '4h20m'),
          ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonText(
          'Thống kê môn học đã ôn tập'.hardcoded,
          style: style(
            color: color.black,
            fontSize: 18.rps,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 16.rps),
        _buildPieChartCard(distribution),
        SizedBox(height: 24.rps),
        CommonText(
          'Chi tiết từng môn học'.hardcoded,
          style: style(
            color: color.black,
            fontSize: 16.rps,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 12.rps),
        ...List.generate(progressItems.length, (index) {
          final item = progressItems[index];
          final colors = [
            const Color(0xFF6A5AE0),
            const Color(0xFF34C759),
            const Color(0xFF007AFF),
            const Color(0xFFFF9500),
          ];
          return Padding(
            padding: EdgeInsets.only(bottom: index == progressItems.length - 1 ? 0 : 12.rps),
            child: _buildSubjectProgressCard(
              title: item.title,
              percent: item.percent,
              time: item.time,
              barColor: colors[index % colors.length],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildPieChartCard(Map<String, double> distribution) {
    final colors = [
      const Color(0xFF6A5AE0),
      const Color(0xFF34C759),
      const Color(0xFF007AFF),
      const Color(0xFFFF9500),
    ];
    final keys = distribution.keys.toList();
    final values = distribution.values.toList();

    return Container(
      padding: EdgeInsets.all(20.rps),
      decoration: BoxDecoration(
        color: color.white,
        borderRadius: BorderRadius.circular(24.rps),
        border: Border.all(color: color.greyscale200),
        boxShadow: [
          BoxShadow(
            color: color.black.withOpacity(0.02),
            blurRadius: 15.rps,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CommonText(
                'Phân bổ môn học'.hardcoded,
                style: style(
                  color: color.black,
                  fontSize: 16.rps,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.rps, vertical: 6.rps),
                decoration: BoxDecoration(
                  color: color.greyscale200,
                  borderRadius: BorderRadius.circular(12.rps),
                ),
                child: Row(
                  children: [
                    CommonText(
                      'Weekly'.hardcoded,
                      style: style(
                        color: color.greyscale700,
                        fontSize: 12.rps,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 4.rps),
                    Icon(Icons.keyboard_arrow_down, size: 16.rps, color: color.greyscale700),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 24.rps),
          SizedBox(
            height: 160.rps,
            width: 160.rps,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: Size(160.rps, 160.rps),
                  painter: _RingChartPainter(
                    percentages: values,
                    colors: colors,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CommonText(
                      'Tổng thời gian'.hardcoded,
                      style: style(
                        color: color.greyscale500,
                        fontSize: 11.rps,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4.rps),
                    CommonText(
                      '15h20m'.hardcoded,
                      style: style(
                        color: color.black,
                        fontSize: 20.rps,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 24.rps),
          Wrap(
            spacing: 16.rps,
            runSpacing: 8.rps,
            alignment: WrapAlignment.center,
            children: List.generate(keys.length, (index) {
              return _buildLegendItem(
                title: keys[index],
                percent: '${(values[index] * 100).toInt()}%',
                legendColor: colors[index % colors.length],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem({
    required String title,
    required String percent,
    required Color legendColor,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10.rps,
          height: 10.rps,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: legendColor,
          ),
        ),
        SizedBox(width: 6.rps),
        CommonText(
          '$title ($percent)',
          style: style(
            color: color.greyscale700,
            fontSize: 12.rps,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildSubjectProgressCard({
    required String title,
    required double percent,
    required String time,
    required Color barColor,
  }) {
    return Container(
      padding: EdgeInsets.all(16.rps),
      decoration: BoxDecoration(
        color: color.white,
        borderRadius: BorderRadius.circular(20.rps),
        border: Border.all(color: color.greyscale200),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CommonText(
                title.hardcoded,
                style: style(
                  color: color.black,
                  fontSize: 16.rps,
                  fontWeight: FontWeight.w700,
                ),
              ),
              CommonText(
                '${(percent * 100).toInt()}%',
                style: style(
                  color: color.primary,
                  fontSize: 14.rps,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 6.rps),
          Row(
            children: [
              Icon(Icons.access_time, size: 14.rps, color: color.greyscale500),
              SizedBox(width: 4.rps),
              CommonText(
                time.hardcoded,
                style: style(
                  color: color.greyscale500,
                  fontSize: 12.rps,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.rps),
          Container(
            width: double.infinity,
            height: 8.rps,
            decoration: BoxDecoration(
              color: color.greyscale50,
              borderRadius: BorderRadius.circular(4.rps),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: percent,
              child: Container(
                decoration: BoxDecoration(
                  color: barColor,
                  borderRadius: BorderRadius.circular(4.rps),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<int> _getDailyTimeSpent(List<ApiReviewActivityData> activities) {
    final daily = List<int>.filled(31, 0);
    if (activities.isEmpty) {
      return [
        30, 10, 20, 45, 5, 15, 50, 60, 25, 30, 
        40, 15, 20, 35, 10, 45, 55, 30, 20, 25, 
        40, 50, 15, 10, 30, 45, 35, 20, 25, 40, 50
      ];
    }
    for (final act in activities) {
      try {
        final date = DateTime.parse(act.date);
        final day = date.day;
        if (day >= 1 && day <= 31) {
          daily[day - 1] += act.timeSpent ~/ 60;
        }
      } catch (e) {
        Log.e('Error parsing activity date: $e');
      }
    }
    return daily;
  }

  Widget _buildTimeTabContent(List<ApiReviewActivityData> activities) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonText(
          'Thống kê thời gian ôn tập'.hardcoded,
          style: style(
            color: color.black,
            fontSize: 18.rps,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 16.rps),
        _buildTimeChartCard(activities),
      ],
    );
  }

  Widget _buildTimeChartCard(List<ApiReviewActivityData> activities) {
    final daysData = _getDailyTimeSpent(activities);

    return Container(
      padding: EdgeInsets.all(20.rps),
      decoration: BoxDecoration(
        color: color.white,
        borderRadius: BorderRadius.circular(24.rps),
        border: Border.all(color: color.greyscale200),
        boxShadow: [
          BoxShadow(
            color: color.black.withOpacity(0.02),
            blurRadius: 15.rps,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CommonText(
                'Thời gian ôn tập (phút)'.hardcoded,
                style: style(
                  color: color.black,
                  fontSize: 16.rps,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.rps, vertical: 6.rps),
                decoration: BoxDecoration(
                  color: color.greyscale200,
                  borderRadius: BorderRadius.circular(12.rps),
                ),
                child: Row(
                  children: [
                    CommonText(
                      'Weekly'.hardcoded,
                      style: style(
                        color: color.greyscale700,
                        fontSize: 12.rps,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 4.rps),
                    Icon(Icons.keyboard_arrow_down, size: 16.rps, color: color.greyscale700),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 24.rps),
          SizedBox(
            height: 200.rps,
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: ['60', '50', '40', '30', '20', '10', '0']
                      .map((val) => SizedBox(
                            width: 24.rps,
                            child: CommonText(
                              val,
                              style: style(
                                color: color.greyscale500,
                                fontSize: 12.rps,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ))
                      .toList(),
                ),
                SizedBox(width: 12.rps),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Stack(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(
                            7,
                            (index) => Container(
                              width: 800.rps,
                              height: 1.rps,
                              color: color.greyscale200,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10.rps, bottom: 24.rps),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: List.generate(daysData.length, (index) {
                              final val = daysData[index];
                              final barHeight = 140.rps * (val / 60).clamp(0.0, 1.0);
                              return Container(
                                margin: EdgeInsets.symmetric(horizontal: 6.rps),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      width: 8.rps,
                                      height: barHeight,
                                      decoration: BoxDecoration(
                                        color: color.primary,
                                        borderRadius: BorderRadius.circular(4.rps),
                                      ),
                                    ),
                                    SizedBox(height: 6.rps),
                                    CommonText(
                                      '${index + 1}',
                                      style: style(
                                        color: color.greyscale500,
                                        fontSize: 10.rps,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartCard(List<ApiReviewActivityData> activities) {
    return Container(
      padding: EdgeInsets.all(20.rps),
      decoration: BoxDecoration(
        color: color.white,
        borderRadius: BorderRadius.circular(24.rps),
        border: Border.all(color: color.greyscale200),
        boxShadow: [
          BoxShadow(
            color: color.black.withOpacity(0.02),
            blurRadius: 15.rps,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CommonText(
                'Độ chính xác'.hardcoded,
                style: style(
                  color: color.black,
                  fontSize: 16.rps,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.rps, vertical: 6.rps),
                decoration: BoxDecoration(
                  color: color.greyscale200,
                  borderRadius: BorderRadius.circular(12.rps),
                ),
                child: Row(
                  children: [
                    CommonText(
                      'Weekly'.hardcoded,
                      style: style(
                        color: color.greyscale700,
                        fontSize: 12.rps,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 4.rps),
                    Icon(Icons.keyboard_arrow_down, size: 16.rps, color: color.greyscale700),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 24.rps),
          SizedBox(
            height: 180.rps,
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: ['100%', '75%', '50%', '25%', '0%']
                      .map((val) => SizedBox(
                            width: 36.rps,
                            child: CommonText(
                              val,
                              style: style(
                                color: color.greyscale500,
                                fontSize: 12.rps,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ))
                      .toList(),
                ),
                SizedBox(width: 12.rps),
                Expanded(
                  child: Stack(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                          5,
                          (index) => Container(
                            height: 1.rps,
                            color: color.greyscale200,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.rps),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _buildBar(
                              week: 'Tuần 1'.hardcoded,
                              score: '${(_getWeekAccuracy(activities: activities, weekIndex: 0) * 10).toInt()}/10',
                              percent: _getWeekAccuracy(activities: activities, weekIndex: 0),
                            ),
                            _buildBar(
                              week: 'Tuần 2'.hardcoded,
                              score: '${(_getWeekAccuracy(activities: activities, weekIndex: 1) * 10).toInt()}/10',
                              percent: _getWeekAccuracy(activities: activities, weekIndex: 1),
                            ),
                            _buildBar(
                              week: 'Tuần 3'.hardcoded,
                              score: '${(_getWeekAccuracy(activities: activities, weekIndex: 2) * 10).toInt()}/10',
                              percent: _getWeekAccuracy(activities: activities, weekIndex: 2),
                            ),
                          ],
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

  Widget _buildBar({
    required String week,
    required String score,
    required double percent,
  }) {
    final barHeight = 120.rps * percent;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CommonText(
          score,
          style: style(
            color: color.primary,
            fontSize: 12.rps,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 6.rps),
        Container(
          width: 32.rps,
          height: barHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.primary, color.primary.withOpacity(0.6)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.vertical(top: Radius.circular(8.rps)),
          ),
        ),
        SizedBox(height: 8.rps),
        CommonText(
          week,
          style: style(
            color: color.greyscale500,
            fontSize: 12.rps,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildSubjectStatusCard({
    required String title,
    required String completion,
    required int correctCount,
    required int incorrectCount,
    required Color statusColor,
  }) {
    return Container(
      padding: EdgeInsets.all(16.rps),
      decoration: BoxDecoration(
        color: color.white,
        borderRadius: BorderRadius.circular(20.rps),
        border: Border.all(color: color.greyscale200),
      ),
      child: Row(
        children: [
          Container(
            width: 6.rps,
            height: 50.rps,
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(3.rps),
            ),
          ),
          SizedBox(width: 12.rps),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText(
                  title.hardcoded,
                  style: style(
                    color: color.black,
                    fontSize: 16.rps,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 6.rps),
                Row(
                  children: [
                    CommonText(
                      'Hoàn thành'.hardcoded,
                      style: style(
                        color: color.greyscale500,
                        fontSize: 12.rps,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 6.rps),
                    Container(
                      width: 4.rps,
                      height: 4.rps,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: color.greyscale500,
                      ),
                    ),
                    SizedBox(width: 6.rps),
                    CommonText(
                      completion,
                      style: style(
                        color: color.primary,
                        fontSize: 12.rps,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CommonText(
                'Đúng: $correctCount'.hardcoded,
                style: style(
                  color: const Color(0xFF34C759),
                  fontSize: 14.rps,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 4.rps),
              CommonText(
                'Sai: $incorrectCount'.hardcoded,
                style: style(
                  color: const Color(0xFFFF3B30),
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
}

class _SubjectProgressItem {
  const _SubjectProgressItem({
    required this.title,
    required this.percent,
    required this.time,
  });

  final String title;
  final double percent;
  final String time;
}

class _RingChartPainter extends CustomPainter {
  final List<double> percentages;
  final List<Color> colors;

  _RingChartPainter({required this.percentages, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 12;
    final rect = Rect.fromCircle(center: center, radius: radius);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.round;

    double startAngle = -3.14159 / 2;
    for (int i = 0; i < percentages.length; i++) {
      paint.color = colors[i % colors.length];
      final sweepAngle = 2 * 3.14159 * percentages[i];
      canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
