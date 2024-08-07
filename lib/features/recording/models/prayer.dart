import 'package:objectbox/objectbox.dart';
import 'package:salah_x/features/recording/models/unit.dart';
import 'package:uuid/uuid.dart';

class Prayer {
  final String? id;
  final String name;
  final List<Unit> units;
  final bool? freshWudhu;
  final bool? atMosque;
  final bool? withCongregation;
  final bool? isQadha;
  final String? reasonForMissingPrayer;
  final String? reasonForMissingCongregation;
  final bool? wasLateForCongregation;
  final int lateByRakats;
  final bool? takbirAlUlaAchieved;
  final String? masjidName;

  const Prayer({
    this.id,
    required this.name,
    required this.units,
    this.freshWudhu,
    this.isQadha,
    this.withCongregation,
    this.atMosque,
    this.reasonForMissingPrayer,
    this.reasonForMissingCongregation,
    this.wasLateForCongregation,
    this.lateByRakats = 0,
    this.takbirAlUlaAchieved,
    this.masjidName,
  });

  // toJson method for serializing the Prayer object to JSON format
  Map<String, dynamic> toJson() => {
        'id': const Uuid().v4(),
        'name': name,
        'units': units.map((unit) => unit.toJson()).toList(),
        'fresh_wudhu': freshWudhu,
        'with_congregation': withCongregation,
        'at_mosque': atMosque,
        'is_qadha': isQadha,
        'reason_for_missing_prayer': reasonForMissingPrayer,
        'reason_for_missing_congregation': reasonForMissingCongregation,
        'was_late_for_congregation': wasLateForCongregation,
        'late_by_rakats': lateByRakats,
        'takbir_al_ula_achieved': takbirAlUlaAchieved,
        'masjid_name': masjidName,
      };

  // fromJson method for creating a Prayer object from a JSON map
  factory Prayer.fromJson(Map<String, dynamic> json) {
    return Prayer(
      id: json['id'] as String,
      name: json['name'] as String,
      units: (json['units'] as List)
          .map((unitJson) => Unit.fromJson(unitJson))
          .toList(),
      isQadha: json['is_qadha'],
      atMosque: json['at_mosque'],
      freshWudhu: json['fresh_wudhu'] as bool?,
      withCongregation: json['with_congregation'] as bool?,
      reasonForMissingPrayer: json['reason_for_missing_prayer'] as String?,
      reasonForMissingCongregation:
          json['reason_for_missing_congregation'] as String?,
      wasLateForCongregation: json['was_late_for_congregation'] as bool?,
      lateByRakats: json['late_by_rakats'] as int,
      takbirAlUlaAchieved: json['takbir_al_ula_achieved'],
      masjidName: json['masjid_name'] as String?,
    );
  }

  // copyWith method for creating a copy of the Prayer object with updated properties
  Prayer copyWith({
    String? id,
    String? name,
    List<Unit>? units,
    bool? freshWudhu,
    bool? withCongregation,
    bool? atMosque,
    bool? isQadha,
    String? reasonForMissingPrayer,
    String? reasonForMissingCongregation,
    bool? wasLateForCongregation,
    int? lateByRakats,
    bool? takbirAlUlaAchieved,
    String? masjidName,
  }) {
    return Prayer(
      id: id ?? this.id,
      name: name ?? this.name,
      units: units ?? this.units,
      freshWudhu: freshWudhu ?? this.freshWudhu,
      withCongregation: withCongregation ?? this.withCongregation,
      reasonForMissingPrayer:
          reasonForMissingPrayer ?? this.reasonForMissingPrayer,
      reasonForMissingCongregation:
          reasonForMissingCongregation ?? this.reasonForMissingCongregation,
      atMosque: atMosque ?? this.atMosque,
      isQadha: isQadha ?? this.isQadha,
      wasLateForCongregation:
          wasLateForCongregation ?? this.wasLateForCongregation,
      lateByRakats: lateByRakats ?? this.lateByRakats,
      takbirAlUlaAchieved: takbirAlUlaAchieved ?? this.takbirAlUlaAchieved,
      masjidName: masjidName ?? this.masjidName,
    );
  }

  Prayer nullify({
    bool? id,
    bool? freshWudhu,
    bool? withCongregation,
    bool? atMosque,
    bool? isQadha,
    bool? reasonForMissingPrayer,
    bool? reasonForMissingCongregation,
    bool? wasLateForCongregation,
    bool? takbirAlUlaAchieved,
    bool? masjidName,
  }) {
    return Prayer(
      id: id == true ? null : this.id,
      name: name,
      units: units,
      lateByRakats: lateByRakats,
      freshWudhu: freshWudhu == true ? null : this.freshWudhu,
      withCongregation: withCongregation == true ? null : this.withCongregation,
      reasonForMissingPrayer:
          reasonForMissingPrayer == true ? null : this.reasonForMissingPrayer,
      reasonForMissingCongregation: reasonForMissingCongregation == true
          ? null
          : this.reasonForMissingCongregation,
      atMosque: atMosque == true ? null : this.atMosque,
      isQadha: isQadha == true ? null : this.isQadha,
      wasLateForCongregation:
          wasLateForCongregation == true ? null : this.wasLateForCongregation,
      takbirAlUlaAchieved:
          takbirAlUlaAchieved == true ? null : this.takbirAlUlaAchieved,
      masjidName: masjidName == true ? null : this.masjidName,
    );
  }
}

@Entity()
class DataPrayer {
  @Id()
  int id = 0;
  String date;
  String data;

  DataPrayer({
    this.id = 0,
    required this.date,
    required this.data,
  });
}
