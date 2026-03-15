import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../index.dart';

final homeViewModelProvider =
    StateNotifierProvider.autoDispose<HomeViewModel, CommonState<HomeState>>(
  (ref) => HomeViewModel(),
);

class HomeViewModel extends BaseViewModel<HomeState> {
  HomeViewModel() : super(const CommonState(data: HomeState()));
}
