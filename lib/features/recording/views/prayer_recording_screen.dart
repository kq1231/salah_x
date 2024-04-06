import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:salah_x/features/recording/controllers/prayer_controller.dart';
import 'package:salah_x/features/recording/models/unit.dart';

class PrayerRecordingScreen extends ConsumerWidget {
  final String date;
  const PrayerRecordingScreen({
    super.key,
    required this.date,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final providerOfPrayers = ref.watch(prayersProvider(date));

    return providerOfPrayers.when(
      data: (prayers) {
        return Scaffold(
          appBar: AppBar(),
          body: ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(height: 20),
            itemBuilder: (context, index) {
              return PrayerSection(
                  name: prayers[index].name, units: prayers[index].units);
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

class PrayerSection extends StatelessWidget {
  final String name;
  final List<Unit> units;

  const PrayerSection({super.key, required this.name, required this.units});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                flex: 5,
                child: Divider(),
              ),
              Container(
                color: Theme.of(context).colorScheme.primary,
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(
                    name,
                    style: TextStyle(
                        fontSize: 18.0,
                        color: Theme.of(context).primaryColorDark),
                  ),
                ),
              ),
              const Expanded(
                flex: 5,
                child: Divider(),
              ),
            ],
          ),
          const SizedBox(height: 8.0), // Add some spacing
          Wrap(
            spacing: 8.0, // spacing between units
            runSpacing: 8.0, // spacing between rows
            children: units.map((unit) => UnitSquare(unit: unit)).toList(),
          ),
        ],
      ),
    );
  }
}

class UnitSquare extends StatelessWidget {
  final Unit unit;

  const UnitSquare({super.key, required this.unit});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 60,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: [
            Colors.orange,
            Colors.yellow,
            Colors.pinkAccent,
            Colors.red,
          ][[UnitType.fardh, UnitType.sunnah, UnitType.nafl, UnitType.witr]
              .indexOf(unit.type)],
          shape: const BeveledRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        ),
        child: Text(
          unit.rakaatCount.toString(),
          style: const TextStyle(color: Colors.black, fontSize: 15.0),
        ),
      ),
    );
  }
}
