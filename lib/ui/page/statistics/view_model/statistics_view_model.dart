import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../index.dart';

final statisticsViewModelProvider =
    StateNotifierProvider.autoDispose<StatisticsViewModel, CommonState<StatisticsState>>(
  (ref) => StatisticsViewModel(ref),
);

class StatisticsViewModel extends BaseViewModel<StatisticsState> {
  StatisticsViewModel(this._ref) : super(const CommonState(data: StatisticsState()));

  final Ref _ref;

  Future<void> init() async {
    await runCatching(
      action: () async {
        final api = _ref.read(appApiServiceProvider);
        final progress = await api.getProgress();
        final activities = await api.getReviewActivities();
        data = data.copyWith(
          progress: progress ?? const ApiUserProgressData(),
          activities: activities,
        );
      },
    );
  }
}
