import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../index.dart';

final reviewMethodViewModelProvider = StateNotifierProvider.autoDispose
    .family<ReviewMethodViewModel, CommonState<ReviewMethodState>, ApiDocumentData>(
  (ref, document) => ReviewMethodViewModel(ref: ref, document: document),
);

class ReviewMethodViewModel extends BaseViewModel<ReviewMethodState> {
  ReviewMethodViewModel({
    required Ref ref,
    required ApiDocumentData document,
  })  : _ref = ref,
        super(CommonState(data: ReviewMethodState(document: document)));

  final Ref _ref;

  Future<void> init() async {
    await runCatching(
      action: () async {
        final api = _ref.read(appApiServiceProvider);
        final list = await api.getSummaries(documentId: data.document.id);
        data = data.copyWith(summaries: list);
      },
    );
  }
}
