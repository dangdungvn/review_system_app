// ignore_for_file: prefer_single_widget_per_file
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../index.dart';

final summaryDetailViewModelProvider = StateNotifierProvider.autoDispose
    .family<SummaryDetailViewModel, CommonState<SummaryDetailState>, SummaryDetailParams>(
  (ref, params) => SummaryDetailViewModel(ref: ref, params: params),
);

class SummaryDetailParams {
  const SummaryDetailParams({
    required this.document,
    required this.summaryId,
  });

  final ApiDocumentData document;
  final int summaryId;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SummaryDetailParams &&
          runtimeType == other.runtimeType &&
          document == other.document &&
          summaryId == other.summaryId;

  @override
  int get hashCode => document.hashCode ^ summaryId.hashCode;
}

class SummaryDetailViewModel extends BaseViewModel<SummaryDetailState> {
  SummaryDetailViewModel({
    required Ref ref,
    required SummaryDetailParams params,
  })  : _ref = ref,
        super(CommonState(
            data: SummaryDetailState(
          document: params.document,
          summaryId: params.summaryId,
        )));

  final Ref _ref;

  Future<void> init() async {
    await runCatching(
      action: () async {
        final api = _ref.read(appApiServiceProvider);
        final detail = await api.getSummaryDetail(id: data.summaryId);
        data = data.copyWith(
          summary: detail,
        );
      },
    );
  }
}
