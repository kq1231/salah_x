import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salah_x/features/recording/models/prayer.dart';
import 'package:salah_x/features/recording/repositories/prayer_repository_impl.dart';

class PrayerNotifier
    extends AutoDisposeFamilyAsyncNotifier<List<Prayer>, String> {
  @override
  FutureOr<List<Prayer>> build(String arg) async {
    return await ref.read(prayerRepositoryProvider.notifier).fetchPrayers(arg);
  }
}

final prayersProvider = AutoDisposeAsyncNotifierProviderFamily<PrayerNotifier,
    List<Prayer>, String>(PrayerNotifier.new);
