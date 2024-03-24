import 'package:flutter/material.dart';
import 'package:salah_x/features/recording/models/unit.dart';

class PrayerRecordingScreen extends StatelessWidget {
  const PrayerRecordingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          // Prayer section widget for Fajr (replace with actual data)
          PrayerSection(
            name: 'Fajr',
            units: [
              Unit(
                type: UnitType.sunnah,
                rakaatCount: 2,
                focusLevel: FocusLevel.high,
                order: 2,
              ),
              Unit(
                type: UnitType.fardh,
                rakaatCount: 2,
                focusLevel: FocusLevel.high,
                order: 2,
              ),
            ],
          ),
          // Prayer section widgets for other prayers (Dhuhr, Asr, ...)
        ],
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
          Text(name, style: const TextStyle(fontSize: 18.0)),
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
      width: 50,
      height: 50,
      child: Ink(
        color: [
          Colors.green,
          Colors.yellow,
          Colors.orange,
          Colors.purple,
        ][[UnitType.fardh, UnitType.sunnah, UnitType.nafl, UnitType.witr]
            .indexOf(unit.type)],
        child: InkWell(
          onTap: () {
            // Handle unit tap
          },
          child: Center(
            child: Text(
              unit.rakaatCount.toString(),
              style: const TextStyle(color: Colors.black, fontSize: 15.0),
            ),
          ),
        ),
      ),
    );
  }
}
