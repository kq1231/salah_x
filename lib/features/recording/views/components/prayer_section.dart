import 'package:flutter/material.dart';
import 'package:salah_x/features/recording/models/unit.dart';
import 'package:salah_x/features/recording/views/components/unit_tile.dart';

class PrayerSection extends StatelessWidget {
  final String name;
  final List<Unit> units;
  final void Function(int unitIndex, bool? value) onChanged;

  const PrayerSection(
      {super.key,
      required this.name,
      required this.units,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    List<UnitTile> unitTiles = [];

    for (int i in Iterable.generate(units.length)) {
      unitTiles.add(UnitTile(
        unit: units[i],
        onChanged: (bool? value) => onChanged(i, value),
      ));
    }

    return Column(
      children: [
        Container(
          color: Colors.black45,
          child: Row(
            children: [
              const Expanded(
                child: Divider(
                  color: Colors.white,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Expanded(
                child: Divider(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 25.0), // Add some spacing

        Wrap(
          spacing: 8.0, // spacing between units
          runSpacing: 8.0, // spacing between rows
          children: unitTiles,
        ),

        const SizedBox(height: 10.0), // Add some spacing
      ],
    );
  }
}
