import 'package:flutter/material.dart';
import 'package:salah_x/features/recording/models/unit.dart';

class UnitTile extends StatelessWidget {
  final Unit unit;
  final void Function(Unit unit) onChanged;

  const UnitTile({
    super.key,
    required this.unit,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        children: [
          Transform.scale(
            scale: 1.2,
            child: Checkbox(
                fillColor: unit.hasPrayed == true
                    ? WidgetStatePropertyAll(Colors.green)
                    : null,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(99)),
                value: unit.hasPrayed ?? false,
                onChanged: (hasPrayed) {
                  onChanged(unit.copyWith(hasPrayed: hasPrayed));
                }),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ExpansionTile(
              collapsedShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              backgroundColor:
                  unit.hasPrayed == true ? Colors.green[600] : Colors.indigo,
              collapsedBackgroundColor:
                  unit.hasPrayed == true ? Colors.green[600] : Colors.indigo,
              title: Text(unit.type.toString().split('.').last),
              leading: CircleAvatar(
                radius: 12,
                child: Text(
                  unit.rakaatCount.toString(),
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 5,
                      ),
                      const CircleAvatar(
                        child: Icon(
                          Icons.center_focus_strong,
                          color: Colors.amber,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text("Focus Level"),
                      const SizedBox(
                        width: 5,
                      ),
                      unit.focusLevel == null
                          ? Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton.outlined(
                                    onPressed: () {
                                      onChanged(unit.copyWith(
                                          focusLevel: FocusLevel.high));
                                    },
                                    icon: const Icon(Icons.add),
                                  ),
                                ],
                              ),
                            )
                          : Expanded(
                              child: Slider(
                                  thumbColor: Colors.amber,
                                  activeColor: Colors.white,
                                  min: 0,
                                  max: 2,
                                  divisions: 2,
                                  label: [
                                    "Not Focused",
                                    "Some Focus",
                                    "Fully Focused"
                                  ][FocusLevel.values
                                      .indexOf(unit.focusLevel!)],
                                  value: FocusLevel.values
                                      .indexOf(unit.focusLevel!)
                                      .toDouble(),
                                  onChanged: (value) {
                                    onChanged(unit.copyWith(
                                        focusLevel:
                                            FocusLevel.values[value.toInt()]));
                                  }),
                            ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
