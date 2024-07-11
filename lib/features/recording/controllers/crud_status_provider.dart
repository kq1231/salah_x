import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class CRUDStatusController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  // Methods
  Future<dynamic> performCRUDOperation(func, {dynamic arg}) async {
    state = const AsyncLoading();
    var res = arg != null ? func(arg) : func();

    await Future.delayed(const Duration(milliseconds: 300));

    state = const AsyncData(null);

    return res;
  }
}

final crudStatusControllerProvider =
    AutoDisposeAsyncNotifierProvider<CRUDStatusController, void>(
        CRUDStatusController.new);
