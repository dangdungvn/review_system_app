import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../index.dart';

final subjectDetailViewModelProvider = StateNotifierProvider.autoDispose
    .family<SubjectDetailViewModel, CommonState<SubjectDetailState>, ApiDocumentData>(
  (ref, document) => SubjectDetailViewModel(ref: ref, document: document),
);

class SubjectDetailViewModel extends BaseViewModel<SubjectDetailState> {
  SubjectDetailViewModel({
    required Ref ref,
    required ApiDocumentData document,
  })  : _ref = ref,
        super(CommonState(data: SubjectDetailState(document: document)));

  final Ref _ref;

  Future<void> init() async {
    await runCatching(
      action: () async {
        var activities = _ref.read(homeViewModelProvider).data.activities;
        if (activities.isEmpty) {
          final api = _ref.read(appApiServiceProvider);
          activities = await api.getReviewActivities();
        }

        final subjectActivities =
            activities.where((e) => e.subjectId == data.document.id.toString()).toList();

        data = data.copyWith(
          activities: subjectActivities,
        );
      },
    );
  }
}
