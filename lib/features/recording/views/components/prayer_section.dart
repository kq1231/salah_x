import 'package:flutter/material.dart';
import 'package:salah_x/features/recording/models/prayer.dart';
import 'package:salah_x/features/recording/models/unit.dart';
import 'package:salah_x/features/recording/views/components/unit_tile.dart';

class PrayerSection extends StatelessWidget {
  final Prayer prayer;
  final List<Unit> units;
  final void Function(int unitIndex, Unit unit) onUnitChanged;
  final void Function(Prayer prayer) onPrayerChanged;

  const PrayerSection({
    super.key,
    required this.prayer,
    required this.units,
    required this.onUnitChanged,
    required this.onPrayerChanged,
  });

  @override
  Widget build(BuildContext context) {
    List<UnitTile> unitTiles = [];

    for (int i in Iterable.generate(units.length)) {
      unitTiles.add(UnitTile(
        unit: units[i],
        onChanged: (Unit unit) => onUnitChanged(i, unit),
      ));
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          color: Color.fromARGB(106, 63, 81, 181),
        ),
        child: Column(
          children: [
            // -------- Name & Choice Chips ----------
            ExpansionTile(
              shape:
                  const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
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
                    alignment: WrapAlignment.center,
                    runSpacing: 6,
                    spacing: 8,
                    children: [
                      ChoiceChip(
                        side: BorderSide.none,
                        backgroundColor: prayer.withCongregation == null
                            ? Colors.grey
                            : Colors.red,
                        selectedColor: Colors.green,
                        label: const Text("With Jama'ah"),
                        selected: prayer.withCongregation ?? false,
                        onSelected: (bool withJamaah) {
                          onPrayerChanged(
                              prayer.copyWith(withCongregation: withJamaah));
                        },
                      ),
                      ChoiceChip(
                        side: BorderSide.none,
                        backgroundColor:
                            prayer.atMosque == null ? Colors.grey : Colors.red,
                        selectedColor: Colors.green,
                        label: const Text("At the Mosque"),
                        selected: prayer.atMosque ?? false,
                        onSelected: (bool atMosque) {
                          onPrayerChanged(prayer.copyWith(atMosque: atMosque));
                        },
                      ),
                      ChoiceChip(
                        side: BorderSide.none,
                        backgroundColor: prayer.freshWudhu == null
                            ? Colors.grey
                            : Colors.black,
                        selectedColor: Colors.green,
                        label: const Text("Fresh Wudhu"),
                        selected: prayer.freshWudhu ?? false,
                        onSelected: (bool freshWudhu) {
                          onPrayerChanged(
                              prayer.copyWith(freshWudhu: freshWudhu));
                        },
                      ),
                      ChoiceChip(
                        side: BorderSide.none,
                        checkmarkColor: Colors.black,
                        backgroundColor: prayer.wasLateForCongregation == null
                            ? Colors.grey
                            : Colors.green,
                        selectedColor: Colors.red,
                        label: const Text("Late for Jama'ah"),
                        selected: prayer.wasLateForCongregation ?? false,
                        onSelected: (bool wasLateForCongregation) {
                          onPrayerChanged(prayer.copyWith(
                              wasLateForCongregation: wasLateForCongregation));
                        },
                      ),
                      ChoiceChip(
                        side: BorderSide.none,
                        backgroundColor: prayer.takbirAlUlaAchieved == null
                            ? Colors.grey
                            : Colors.black12,
                        selectedColor: Colors.green,
                        label: const Text("Takbir al Ula"),
                        selected: prayer.takbirAlUlaAchieved ?? false,
                        onSelected: (bool takbirAlUlaAchieved) {
                          onPrayerChanged(prayer.copyWith(
                              takbirAlUlaAchieved: takbirAlUlaAchieved));
                        },
                      ),
                      ChoiceChip(
                        side: BorderSide.none,
                        checkmarkColor: Colors.black,
                        backgroundColor:
                            prayer.isQadha == false || prayer.isQadha == null
                                ? Colors.grey
                                : Colors.green,
                        selectedColor: Colors.red,
                        label: const Text("Missed the Prayer"),
                        selected: prayer.isQadha ?? false,
                        onSelected: (bool isQadha) {
                          onPrayerChanged(prayer.copyWith(isQadha: isQadha));
                        },
                      ),
                    ],
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    onPrayerChanged(
                      prayer.nullify(
                        withCongregation: true,
                        atMosque: true,
                        freshWudhu: true,
                        wasLateForCongregation: true,
                        takbirAlUlaAchieved: true,
                        isQadha: true,
                      ),
                    );
                  },
                  icon: const Icon(Icons.close),
                  label: const Text("Reset"),
                ),
                const SizedBox(height: 10.0), // Add some spacing
              ],
            ),

            // -------- Unit Tiles ----------
            ...unitTiles.map((e) => Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  child: e,
                )),

            const SizedBox(height: 10.0), // Add some spacing
          ],
        ),
      ),
    );
  }
}
