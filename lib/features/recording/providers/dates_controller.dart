import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salah_x/features/recording/providers/crud_status_provider.dart';
import 'package:salah_x/features/recording/repositories/prayer_repository_impl.dart';

class DatesNotifier extends AsyncNotifier<Map<int, Map<int, List<int>>>> {
  @override
  FutureOr<Map<int, Map<int, List<int>>>> build() async {
    return await ref.read(prayerRepositoryProvider.notifier).getDates();
  }

  // Methods
  Future<bool> createPrayers(DateTime date) async {
    bool status = await ref
        .read(crudStatusControllerProvider.notifier)
        .performCRUDOperation(
          ref.read(prayerRepositoryProvider.notifier).createPrayers,
          arg: date.toString().substring(0, 10),
        );

    ref.invalidateSelf();
    return status;
  }

  Future<void> deletePrayers(String date) async {
    await ref.read(crudStatusControllerProvider.notifier).performCRUDOperation(
          ref.read(prayerRepositoryProvider.notifier).deletePrayers,
          arg: date.toString().substring(0, 10),
        );

    ref.invalidateSelf();
  }
}

final datesProvider =
    AsyncNotifierProvider<DatesNotifier, Map<int, Map<int, List<int>>>>(
        DatesNotifier.new);
