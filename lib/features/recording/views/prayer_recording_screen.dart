import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:salah_x/features/recording/controllers/dates_controller.dart';
import 'package:salah_x/features/recording/controllers/prayer_controller.dart';
import 'package:salah_x/features/recording/repositories/prayer_repository_impl.dart';
import 'package:salah_x/features/recording/views/components/prayer_section.dart';

class PrayerRecordingScreen extends ConsumerStatefulWidget {
  final String date;
  const PrayerRecordingScreen({
    super.key,
    required this.date,
  });

  @override
  ConsumerState<PrayerRecordingScreen> createState() =>
      _PrayerRecordingScreenState();
}

class _PrayerRecordingScreenState extends ConsumerState<PrayerRecordingScreen> {
  @override
  Widget build(BuildContext context) {
    final providerOfPrayers = ref.watch(prayersProvider(widget.date));

    return providerOfPrayers.when(
      data: (prayers) {
        return Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    ref.read(datesProvider.notifier).deletePrayers(widget.date);
                  },
                  icon: const Icon(Icons.delete_forever))
            ],
          ),
          body: ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(height: 20),
            itemBuilder: (context, index) {
              return PrayerSection(
                name: prayers[index].name,
                units: prayers[index].units,
                onChanged: (unitIndex, value) {
                  // Change the status
                  prayers[index].units[unitIndex] = prayers[index]
                      .units[unitIndex]
                      .copyWith(hasPrayed: value);

                  // Trigger a rebuild
                  setState(() {});

                  // Update the database
                  ref
                      .read(prayerRepositoryProvider.notifier)
                      .updatePrayer(widget.date, prayers[index], index);
                },
              );
            },
            itemCount: prayers.length,
          ),
        );
      },
      error: (_, __) => const Text("Error"),
      loading: () => SpinKitCircle(
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
