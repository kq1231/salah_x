import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salah_x/features/recording/providers/prayer_timings_provider.dart';
import 'package:salah_x/features/recording/repositories/prayer_repository_impl.dart';
import 'package:salah_x/init/store_provider.dart';
import 'package:salah_x/notifs/prayer_notification_service.dart';

final startupProvider = FutureProvider<void>((ref) async {
  String date = DateTime.now().toString().substring(0, 10);

  ref.onDispose(() {
    // In case any provider fails, refresh it
    ref.invalidate(storeProvider);
  });

  // First, init the db
  await ref.read(storeProvider.future);

  // Then create today's data if not already there
  await ref.read(prayerRepositoryProvider.notifier).createPrayers(date);

  // Fetch prayer timings
  await ref.read(prayerTimingsProvider.future);

  await ref.read(notificationServiceProvider.notifier).scheduleAllNotifications(
      ref
          .read(prayerTimingsProvider)
          .requireValue
          .map((e) => DateTime.now().copyWith(hour: e.hour, minute: e.minute))
          .toList()..removeAt(1));
});
