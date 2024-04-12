import 'package:flutter/material.dart';
import 'package:salah_x/features/recording/models/unit.dart';

class UnitTile extends StatelessWidget {
  final Unit unit;
  final void Function(bool? value) onChanged;

  const UnitTile({
    super.key,
    required this.unit,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 4,
          decoration: BoxDecoration(
              color: [
            Colors.orange,
            Colors.yellow,
            Colors.pinkAccent,
            Colors.red,
          ][[UnitType.fardh, UnitType.sunnah, UnitType.nafl, UnitType.witr]
                  .indexOf(unit.type)]),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            unit.rakaatCount.toString(),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        Container(
          width: 20,
          height: 4,
          decoration: BoxDecoration(
              color: [
            Colors.orange,
            Colors.yellow,
            Colors.pinkAccent,
            Colors.red,
          ][[UnitType.fardh, UnitType.sunnah, UnitType.nafl, UnitType.witr]
                  .indexOf(unit.type)]),
        ),
        Expanded(
          child: CheckboxListTile(
              value: unit.hasPrayed ?? false,
              onChanged: onChanged,
              title: Text(unitTypeAsString(unit.type)),
              shape: BeveledRectangleBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                side: BorderSide(
                  width: 2,
                  color: [
                    Colors.orange,
                    Colors.yellow,
                    Colors.pinkAccent,
                    Colors.red,
                  ][[
                    UnitType.fardh,
                    UnitType.sunnah,
                    UnitType.nafl,
                    UnitType.witr
                  ].indexOf(unit.type)],
                ),
              ),
              tileColor: [
                Colors.orange,
                Colors.yellow,
                Colors.pinkAccent,
                Colors.red,
              ][[UnitType.fardh, UnitType.sunnah, UnitType.nafl, UnitType.witr]
                      .indexOf(unit.type)]
                  .withOpacity(0.3)
              // checkboxShape: const BeveledRectangleBorder(
              //     borderRadius: BorderRadius.all(Radius.circular(5))),
              // fillColor: const MaterialStatePropertyAll(Colors.black),
              // checkColor: Colors.white,
              ),
        ),
        const SizedBox(
          width: 10,
        ),
      ],
    );
  }
}
