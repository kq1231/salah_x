import 'package:salah_x/features/recording/tokens.dart';

class Unit {
  final UnitType
      type; // Unit UnitType (e.g., "Fardh", "Sunnah", "Witr", "Nafl")
  final int rakaatCount; // The number of rak'aat
  final FocusLevel?
      focusLevel; // Enum representing focus levels (e.g., "High", "Moderate", "Low")
  final bool? hasPrayed;
  // final int? order; // Order in which the unit was offered within the prayer
  late final int xp; // Number of points

  Unit({
    required this.type,
    this.focusLevel,
    this.hasPrayed,
    // this.order,
    required this.rakaatCount,
  }) {
    xp = unitXps[type];
  }

  // toJson method for serializing the Unit object to JSON format
  Map<String, dynamic> toJson() => {
        'type': unitTypeAsString(type),
        'focus_level':
            focusLevel?.name.toLowerCase(), // convert enum to lowercase string
        // 'order': order,
        'rakaat_count': rakaatCount,
        'has_prayed': hasPrayed,
      };

  // fromJson method for creating a Unit object from a JSON map
  factory Unit.fromJson(Map<String, dynamic> json) {
    return Unit(
      type: stringAsUnitType(json['type']),
      rakaatCount: json['rakaat_count'] as int,
      focusLevel: json['focus_level'] != null
          ? FocusLevel.values.firstWhere((element) =>
              element.name.toLowerCase() == json['focus_level'] as String)
          : null,
      // order: json['order'] as int?,
      hasPrayed: json['has_prayed'] as bool?,
    );
  }

  // copyWith method for creating a copy of the Unit object with updated properties
  Unit copyWith({
    UnitType? type,
    int? rakaatCount,
    FocusLevel? focusLevel,
    bool? hasPrayed,
    int? order,
  }) {
    return Unit(
      type: type ?? this.type,
      rakaatCount: rakaatCount ?? this.rakaatCount,
      focusLevel: focusLevel ?? this.focusLevel,
      hasPrayed: hasPrayed ?? this.hasPrayed,
      // order: order ?? this.order,
    );
  }
}

enum FocusLevel {
  low,
  moderate,
  high,
}

enum UnitType {
  fardh,
  sunnah,
  witr,
  nafl,
}

Map unitXps = {
  UnitType.fardh: XP.fardh,
  UnitType.sunnah: XP.sunnah,
  UnitType.nafl: XP.nafl,
  UnitType.witr: XP.witr,
};

String unitTypeAsString(UnitType type) {
  return 'fardh,sunnah,nafl,witr'.split(',')[[
    UnitType.fardh,
    UnitType.sunnah,
    UnitType.nafl,
    UnitType.witr
  ].indexOf(type)];
}

UnitType stringAsUnitType(String type) {
  return [
    UnitType.fardh,
    UnitType.sunnah,
    UnitType.nafl,
    UnitType.witr
  ]['fardh,sunnah,nafl,witr'.split(',').indexOf(type)];
}
