import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:salah_x/features/recording/controllers/dates_controller.dart';
import 'package:salah_x/features/recording/views/prayer_recording_screen.dart';

class DatesScreen extends ConsumerWidget {
  const DatesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<Map<int, Map<int, List<int>>>> dates =
        ref.watch(datesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Date View'),
      ),
      body: dates.when(
        data: (data) {
          if (data.isEmpty) {
            return const Center(child: Text('No prayer data found'));
          }
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final year = data.keys.elementAt(index);
              final monthsWithDates = data[year]!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: Theme.of(context).colorScheme.primary,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 4.0,
                          ),
                          child: Text(
                            '$year',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColorDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true, // Prevent nested list from overflowing
                    physics:
                        const NeverScrollableScrollPhysics(), // Disable scrolling
                    itemCount: monthsWithDates.length,
                    itemBuilder: (context, monthIndex) {
                      final month = monthsWithDates.keys.elementAt(monthIndex);
                      final datesList = monthsWithDates[month]!..sort();

                      // Display month name
                      return Column(
                        children: [
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Expanded(
                                child: Divider(),
                              ),
                              Container(
                                color: Theme.of(context).colorScheme.primary,
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Text(
                                    getMonthName(month),
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Theme.of(context).primaryColorDark,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const Expanded(
                                child: Divider(),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            // Use Wrap to display dates horizontally
                            spacing: 2.0, // Add spacing between dates
                            runSpacing: 2.0,
                            children: datesList
                                .map((day) =>
                                    _buildDateButton(context, year, month, day))
                                .toList(),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              );
            },
          );
        },
        loading: () => SpinKitCircle(
          color: Theme.of(context).colorScheme.primary,
        ),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const BeveledRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        onPressed: () => _createPrayers(context, ref),
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }

  Widget _buildDateButton(BuildContext context, int year, int month, int day) {
    return SizedBox(
      width: 70,
      height: 70,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColorDark,
          shape: const BeveledRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        ),
        onPressed: () => _navigateToPrayerRecording(context, year, month, day),
        child: Text(
          '$day',
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }

  void _navigateToPrayerRecording(
      BuildContext context, int year, int month, day) {
    // Use go_router to navigate to PrayerRecordingScreen
    // Pass year, month, and dates as arguments
    // Replace with your actual navigation logic using go_router
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PrayerRecordingScreen(
            date: DateTime(year, month, day).toString().substring(0, 10)),
      ),
    );
  }

  String getMonthName(int month) {
    // Implement logic to return the month name based on the month number (e.g., switch statement)
    // Replace with your actual month name conversion logic

    return 'January,February,March,April,May,June,July,August,September,October,November,December'
        .split(",")[month - 1];
  }

  _createPrayers(BuildContext context, WidgetRef ref) async {
    // Show the calender
    DateTime? selection = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().copyWith(year: DateTime.now().year - 50),
      lastDate: DateTime.now().copyWith(day: DateTime.now().day + 1),
    );

    if (selection != null) {
      bool status =
          await ref.read(datesProvider.notifier).createPrayers(selection);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            content: Text(
              status == true
                  ? "Prayers Created"
                  : "Prayers for ${selection.toString().substring(0, 10)} already exist!",
              style: TextStyle(
                color: Theme.of(context).colorScheme.inverseSurface,
              ),
            ),
          ),
        );
      }
    }
  }
}
