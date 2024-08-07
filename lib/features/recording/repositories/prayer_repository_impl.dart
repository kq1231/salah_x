import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salah_x/features/recording/models/prayer.dart';
import 'package:salah_x/features/recording/models/unit.dart';
import 'package:salah_x/features/recording/repositories/prayer_repository_skeleton.dart';
import 'package:salah_x/init/store_provider.dart';
import 'package:salah_x/objectbox.g.dart';

class PrayerRepository extends AsyncNotifier<void>
    implements PrayerRepositorySkeleton {
  late Store _store;
  late Box<DataPrayer> _prayerBox;

  @override
  FutureOr<void> build() {
    _store = ref.read(storeProvider).requireValue;
    _prayerBox = _store.box<DataPrayer>();
  }

  @override
  Future<Map<int, Map<int, List<int>>>> getDates() async {
    final query = _prayerBox.query().build();

    List<DateTime> dateTimes = query
        .property(DataPrayer_.date)
        .find()
        .map((e) => DateTime.parse(e))
        .toList();

    query.close();

// Initialize the map
    Map<int, Map<int, List<int>>> dateMap = {};

    // Iterate through each DateTime object
    for (DateTime dateTime in dateTimes) {
      int year = dateTime.year;
      int month = dateTime.month;
      int day = dateTime.day;

      // If the year is not already in the map, add it
      if (!dateMap.containsKey(year)) {
        dateMap[year] = {};
      }

      // If the month is not already in the map for this year, add it
      if (!dateMap[year]!.containsKey(month)) {
        dateMap[year]![month] = [];
      }

      // Add the day to the list for this month and year
      dateMap[year]![month]!.add(day);
    }

    return dateMap;
  }

  @override
  Future<bool> createPrayers(String date) async {
    // Create default prayers with units
    final List<Prayer> prayers = [
      Prayer(
        name: 'Fajr',
        units: [
          Unit(
            type: UnitType.sunnah,
            rakaatCount: 2,
          ),
          Unit(
            type: UnitType.fardh,
            rakaatCount: 2,
          )
        ],
      ),
      Prayer(
        name: 'Dhuhr',
        units: [
          Unit(
            type: UnitType.sunnah,
            rakaatCount: 4,
          ),
          Unit(
            type: UnitType.fardh,
            rakaatCount: 4,
          ),
          Unit(
            type: UnitType.sunnah,
            rakaatCount: 2,
          ),
          Unit(
            type: UnitType.nafl,
            rakaatCount: 2,
          ),
        ],
      ),
      Prayer(
        name: "Asr",
        units: [
          Unit(
            type: UnitType.sunnah,
            rakaatCount: 4,
          ),
          Unit(
            type: UnitType.fardh,
            rakaatCount: 4,
          ),
        ],
      ),
      Prayer(
        name: "Maghrib",
        units: [
          Unit(
            type: UnitType.fardh,
            rakaatCount: 3,
          ),
          Unit(
            type: UnitType.sunnah,
            rakaatCount: 2,
          ),
          Unit(
            type: UnitType.nafl,
            rakaatCount: 2,
          ),
        ],
      ),
      Prayer(
        name: "Isha",
        units: [
          Unit(
            type: UnitType.sunnah,
            rakaatCount: 4,
          ),
          Unit(
            type: UnitType.fardh,
            rakaatCount: 4,
          ),
          Unit(
            type: UnitType.sunnah,
            rakaatCount: 2,
          ),
          Unit(
            type: UnitType.witr,
            rakaatCount: 3,
          ),
        ],
      ),
    ];

    // If it is Jumu'ah today, replace 'dhuhr' with 'jumuah'
    if (DateTime.parse(date).weekday == 5) {
      prayers[1] = Prayer(
        name: 'Jumuah',
        units: [
          Unit(
            type: UnitType.sunnah,
            rakaatCount: 4,
          ),
          Unit(
            type: UnitType.fardh,
            rakaatCount: 2,
          ),
          Unit(
            type: UnitType.sunnah,
            rakaatCount: 4,
          ),
          Unit(
            type: UnitType.sunnah,
            rakaatCount: 2,
          ),
        ],
      );
    }

    final query = _prayerBox.query(DataPrayer_.date.equals(date)).build();
    if (query.count() == 0) {
      _prayerBox.put(DataPrayer(
          date: date,
          data: jsonEncode(prayers.map((prayer) => prayer.toJson()).toList())));
      query.close();
      return true;
    }
    query.close();
    return false;
  }

  Future<DataPrayer> fetchDataPrayer(String date) async {
    final query = _prayerBox.query(DataPrayer_.date.equals(date)).build();

    DataPrayer dataPrayer = (await query.findAsync()).first;

    query.close();

    return dataPrayer;
  }

  @override
  Future<List<Prayer>> fetchPrayers(String date) async {
    DataPrayer dataPrayer = await fetchDataPrayer(date);
    List<Prayer> prayers = [];
    List prayersJson = jsonDecode(dataPrayer.data);
    for (Map<String, dynamic> json in prayersJson) {
      prayers.add(Prayer.fromJson(json));
    }

    return prayers;
  }

  @override
  Future<void> updatePrayer(String date, Prayer prayer, int prayerIndex) async {
    DataPrayer dataPrayer = await fetchDataPrayer(date);
    List<Prayer> prayers = [];
    List prayersJson = jsonDecode(dataPrayer.data);
    for (Map<String, dynamic> json in prayersJson) {
      prayers.add(Prayer.fromJson(json));
    }

    prayers[prayerIndex] = prayer;

    _prayerBox.put(DataPrayer(
        id: dataPrayer.id,
        date: date,
        data: jsonEncode(prayers.map((prayer) => prayer.toJson()).toList())));
  }

  @override
  Future<void> deletePrayers(String date) async {
    final query = _prayerBox.query(DataPrayer_.date.equals(date)).build();
    _prayerBox.remove(query.property(DataPrayer_.id).find().first);
  }
}

final prayerRepositoryProvider =
    AsyncNotifierProvider<PrayerRepository, void>(PrayerRepository.new);
