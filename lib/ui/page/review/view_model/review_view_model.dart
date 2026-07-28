import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../index.dart';

final reviewViewModelProvider =
    StateNotifierProvider.autoDispose<ReviewViewModel, CommonState<ReviewState>>(
  (ref) => ReviewViewModel(ref),
);

class ReviewViewModel extends BaseViewModel<ReviewState> {
  ReviewViewModel(this._ref) : super(const CommonState(data: ReviewState()));

  final Ref _ref;

  Future<void> init() async {
    await runCatching(
      action: () async {
        final api = _ref.read(appApiServiceProvider);
        final docs = await api.getDocuments(page: 1, limit: 10);
        final recs = await api.getRecommendations();
        data = data.copyWith(
          documents: docs,
          recommendations: recs,
        );
      },
    );
  }
}
