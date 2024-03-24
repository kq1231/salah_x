import 'package:salah_x/features/recording/tokens.dart';

class Unit {
  final UnitType
      type; // Unit UnitType (e.g., "Fardh", "Sunnah", "Witr", "Nafl")
  final int rakaatCount; // The number of rak'aat
  final FocusLevel?
      focusLevel; // Enum representing focus levels (e.g., "High", "Moderate", "Low")
  final bool? hasPrayed;
  final bool?
      isQada; // Nullable boolean flag indicating if the unit is Qada (only applicable for specific units)
  final int? order; // Order in which the unit was offered within the prayer
  late final int xp; // Number of points

  Unit({
    required this.type,
    this.focusLevel,
    this.isQada,
    this.hasPrayed,
    this.order,
    required this.rakaatCount,
  }) {
    xp = unitXps[type];
  }

  // toJson method for serializing the Unit object to JSON format
  Map<String, dynamic> toJson() => {
        'type': "",
        'focus_level': focusLevel != null
            ? focusLevel!.name.toLowerCase()
            : null, // convert enum to lowercase string
        'is_qada': isQada,
        'order': order,
        'has_prayed': hasPrayed,
      };

  // fromJson method for creating a Unit object from a JSON map
  factory Unit.fromJson(Map<String, dynamic> json) {
    return Unit(
      type: json['type'] as UnitType,
      rakaatCount: json['rakaat_count'] as int,
      focusLevel: json['focus_level'] != null
          ? FocusLevel.values.firstWhere((element) =>
              element.name.toLowerCase() == json['focus_level'] as String)
          : null,
      isQada: json['is_qada'] as bool?,
      order: json['order'] as int,
      hasPrayed: json['has_prayed'] as bool?,
    );
  }

  // copyWith method for creating a copy of the Unit object with updated properties
  Unit copyWith({
    UnitType? type,
    int? rakaatCount,
    FocusLevel? focusLevel,
    bool? hasPrayed,
    bool? isQada,
    int? order,
  }) {
    return Unit(
      type: type ?? this.type,
      rakaatCount: rakaatCount ?? this.rakaatCount,
      focusLevel: focusLevel ?? this.focusLevel,
      hasPrayed: hasPrayed ?? this.hasPrayed,
      isQada: isQada ?? this.isQada,
      order: order ?? this.order,
    );
  }
}

enum FocusLevel {
  high,
  moderate,
  low,
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
