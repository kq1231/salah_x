import 'package:flutter/material.dart';
import 'package:salah_x/features/recording/models/prayer.dart';
import 'package:salah_x/features/recording/models/unit.dart';
import 'package:salah_x/features/recording/views/components/unit_tile.dart';

class PrayerSection extends StatelessWidget {
  final Prayer prayer;
  final List<Unit> units;
  final void Function(int unitIndex, Unit unit) onUnitChanged;

  const PrayerSection(
      {super.key,
      required this.prayer,
      required this.units,
      required this.onUnitChanged});

  @override
  Widget build(BuildContext context) {
    List<UnitTile> unitTiles = [];

    for (int i in Iterable.generate(units.length)) {
      unitTiles.add(UnitTile(
        unit: units[i],
        onChanged: (Unit unit) => onUnitChanged(i, unit),
      ));
    }

    return Container(
      color: const Color.fromARGB(106, 63, 81, 181),
      child: Column(
        children: [
          // -------- Name & Choice Chips ----------
          ExpansionTile(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            title: Text(
              prayer.name,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  runSpacing: 4,
                  spacing: 4,
                  children: [
                    ChoiceChip(
                      backgroundColor: Colors.black38,
                      selectedColor: Colors.green,
                      label: Text("With Jama'ah"),
                      selected: true,
                      onSelected: (bool withJamaah) {},
                    ),
                    ChoiceChip(
                      backgroundColor: Colors.black38,
                      selectedColor: Colors.green,
                      label: Text("At the Mosque"),
                      selected: true,
                      onSelected: (bool atMosque) {},
                    ),
                    ChoiceChip(
                      backgroundColor: Colors.black38,
                      selectedColor: Colors.green,
                      label: Text("Fresh Wudhu"),
                      selected: true,
                      onSelected: (bool freshWudhu) {},
                    ),
                    ChoiceChip(
                      backgroundColor: Colors.green,
                      selectedColor: Colors.red,
                      label: Text("Late for Jama'ah"),
                      selected: true,
                      onSelected: (bool lateForJamaah) {},
                    ),
                    ChoiceChip(
                      backgroundColor: Colors.green,
                      selectedColor: Colors.red,
                      label: Text("Takbir al Ula"),
                      selected: true,
                      onSelected: (bool takbirAlUla) {},
                    ),
                    ChoiceChip(
                      selectedColor: Colors.green,
                      label: Text("Missed the Prayer"),
                      selected: true,
                      onSelected: (bool missedThePrayer) {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10.0), // Add some spacing
            ],
          ),

          // -------- Unit Tiles ----------
          ...unitTiles,

          const SizedBox(height: 10.0), // Add some spacing
        ],
      ),
    );
  }
}
