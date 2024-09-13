import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salah_x/countdown/prayer_countdown.dart';
import 'package:salah_x/features/recording/providers/prayer_timings_provider.dart';

class PrayerCountdownPage extends ConsumerWidget {
  const PrayerCountdownPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<DateTime> prayerTimings = ref
        .read(prayerTimingsProvider)
        .requireValue
        .map(
          (e) => DateTime.now()
              .copyWith(hour: e.hour, minute: e.minute, second: 00),
        )
        .toList();
    return Scaffold(
      body: prayerTimings.isNotEmpty
          ? PrayerCountdown(prayerTimes: prayerTimings)
          : const Center(
              child: Text(
                "There was a problem fetching prayer timings... Check your internet and try again...",
              ),
            ),
    );
  }
}
