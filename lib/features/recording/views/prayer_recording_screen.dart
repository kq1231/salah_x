import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:salah_x/features/recording/providers/crud_status_provider.dart';
import 'package:salah_x/features/recording/providers/dates_controller.dart';
import 'package:salah_x/features/recording/providers/prayer_controller.dart';
import 'package:salah_x/features/recording/providers/prayer_timings_provider.dart';
import 'package:salah_x/features/recording/repositories/prayer_repository_impl.dart';
import 'package:salah_x/features/recording/views/components/prayer_section.dart';
import 'package:salah_x/features/recording/views/dates_screen.dart';

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
            leading: DrawerButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const DatesScreen(),
              )),
            ),
            title: Text(DateFormat(DateFormat.ABBR_MONTH_DAY)
                .format(DateTime.parse(widget.date))),
            actions: [
              ref.watch(crudStatusControllerProvider) is AsyncLoading
                  ? const Tooltip(
                      message: "Syncing...",
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.done),
                      tooltip: "In Sync",
                    ),
              IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                            title: Text(
                                "Are you really sure you want to delete all data for ${DateFormat(DateFormat.ABBR_MONTH_DAY).format(DateTime.parse(widget.date))}?"),
                            actions: [
                              IconButton(
                                  icon: const Icon(Icons.cancel),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  }),
                              IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context)
                                      .pushReplacement(MaterialPageRoute(
                                    builder: (context) => const DatesScreen(),
                                  ));

                                  ref
                                      .read(datesProvider.notifier)
                                      .deletePrayers(widget.date);
                                },
                                icon: const Icon(Icons.done),
                              ),
                            ]);
                      },
                    );
                  },
                  icon: const Icon(Icons.delete_forever))
            ],
          ),
          body: ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(height: 20),
            itemBuilder: (context, index) {
              return PrayerSection(
                prayer: prayers[index],
                time: DateTime.parse(widget.date) ==
                        DateTime(DateTime.now().year, DateTime.now().month,
                            DateTime.now().day)
                    ? ref.read(prayerTimingsProvider).requireValue.isNotEmpty
                        ? ref.read(prayerTimingsProvider).requireValue[index]
                        : null
                    : null,
                units: prayers[index].units,
                onPrayerChanged: (prayer) {
                  prayers[index] = prayer;

                  // Trigger a rebuild
                  setState(() {});

                  // Update the database
                  ref
                      .read(crudStatusControllerProvider.notifier)
                      .performCRUDOperation(() async => ref
                          .read(prayerRepositoryProvider.notifier)
                          .updatePrayer(widget.date, prayers[index], index));
                },
                onUnitChanged: (unitIndex, unit) {
                  // Change the status
                  prayers[index].units[unitIndex] = unit;

                  // Trigger a rebuild
                  setState(() {});

                  // Update the database
                  ref
                      .read(crudStatusControllerProvider.notifier)
                      .performCRUDOperation(() => ref
                          .read(prayerRepositoryProvider.notifier)
                          .updatePrayer(widget.date, prayers[index], index));
                },
              );
            },
            itemCount: prayers.length,
          ),
        );
      },
      error: (_, __) => Text("Error $_ $__"),
      loading: () => SpinKitCircle(
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
