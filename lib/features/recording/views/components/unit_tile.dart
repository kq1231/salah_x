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
      child: ExpansionTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        backgroundColor: Colors.blueGrey,
        collapsedBackgroundColor: Colors.indigo,
        title: Text(unit.type.toString().split('.').last),
        leading: Text(unit.rakaatCount.toString()),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Icon(Icons.center_focus_strong),
              const Text("Focus Level"),
              Slider(
                  min: 0,
                  max: 2,
                  divisions: 2,
                  label: [
                    "Not Focused",
                    "Some Focus",
                    "Fully Focused"
                  ][FocusLevel.values.indexOf(unit.focusLevel)],
                  value: FocusLevel.values.indexOf(unit.focusLevel).toDouble(),
                  onChanged: (value) {
                    onChanged(unit.copyWith(
                        focusLevel: FocusLevel.values[value.toInt()]));
                  }),
            ],
          )
        ],
      ),
    );
  }
}
