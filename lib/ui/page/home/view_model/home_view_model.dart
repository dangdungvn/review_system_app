import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../index.dart';

final homeViewModelProvider =
    StateNotifierProvider.autoDispose<HomeViewModel, CommonState<HomeState>>(
  (ref) => HomeViewModel(ref),
);

class HomeViewModel extends BaseViewModel<HomeState> {
  HomeViewModel(this._ref) : super(const CommonState(data: HomeState()));

  final Ref _ref;

  Future<void> init() async {
    await runCatching(
      action: () async {
        final api = _ref.read(appApiServiceProvider);
        final activities = await api.getReviewActivities();
        final docs = _extractAndSortSubjects(activities);
        data = data.copyWith(
          documents: docs,
          activities: activities,
        );
      },
    );
  }

  List<ApiDocumentData> _extractAndSortSubjects(List<ApiReviewActivityData> activities) {
    final subjectLatestDates = <String, DateTime>{};
    final subjectTitles = <String, String>{};
    final subjectExerciseCounts = <String, Set<String>>{};

    for (final act in activities) {
      if (act.subjectId.isEmpty) continue;
      subjectTitles[act.subjectId] = act.subjectTitle;
      subjectExerciseCounts.putIfAbsent(act.subjectId, () => {}).add(act.exerciseId);

      final date =
          DateTime.tryParse(act.completedAt.isNotEmpty ? act.completedAt : act.startedAt) ??
              DateTime(1970);
      final currentLatest = subjectLatestDates[act.subjectId];
      if (currentLatest == null || date.isAfter(currentLatest)) {
        subjectLatestDates[act.subjectId] = date;
      }
    }

    final sortedSubjectIds = subjectLatestDates.keys.toList()
      ..sort((a, b) {
        final dateA = subjectLatestDates[a]!;
        final dateB = subjectLatestDates[b]!;
        return dateB.compareTo(dateA);
      });

    return sortedSubjectIds.map((subId) {
      final title = subjectTitles[subId] ?? 'Môn học'.hardcoded;
      final exerciseCount = subjectExerciseCounts[subId]?.length ?? 0;
      return ApiDocumentData(
        id: int.tryParse(subId) ?? 0,
        title: title,
        description: '$exerciseCount tài liệu đã ôn'.hardcoded,
      );
    }).toList();
  }
}
