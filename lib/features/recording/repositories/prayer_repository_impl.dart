import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salah_x/features/recording/models/prayer.dart';
import 'package:salah_x/features/recording/models/unit.dart';
import 'package:salah_x/features/recording/repositories/prayer_repository_skeleton.dart';
import 'package:salah_x/init/database_file_provider.dart';

class PrayerRepository extends Notifier<void>
    implements PrayerRepositorySkeleton {
  @override
  build() {}

  @override
  Future<Map<int, Map<int, List<int>>>> getDates() async {
    // Read the file
    // Extract the dates in the form {year: {month: [dates]}}

    File file = ref.read(databaseFileProvider).requireValue;

    final jsonData = await file.readAsString();
    final content = jsonDecode(jsonData);

    // Initialize the result map
    final dates =
        <int, Map<int, List<int>>>{}; // example: {2024: {5: [29, 31, 30]}}

    // Loop through each date entry
    for (var dateEntry in content.entries) {
      final dateString = dateEntry.key; // "2024-03-12"

      // Extract year and month from the date string
      final DateTime date = DateTime.parse(dateString);
      final year = date.year;
      final month = date.month;

      // Update the result map
      if (!dates.containsKey(year)) {
        dates[year] = {};
      }

      if (!dates[year]!.containsKey(month)) {
        dates[year]![month] = [];
      }

      dates[year]![month]!.add(date.day);
    }

    return dates;
  }

  @override
  Future<bool> createPrayers(String date) async {
    File file = ref.read(databaseFileProvider).requireValue;

    // Create default prayers with units
    final List prayers = [
      Prayer(
        withCongregation: true,
        atMosque: true,
        freshWudhu: false,
        name: 'Fajr',
        units: [
          Unit(
            type: UnitType.sunnah,
            focusLevel: FocusLevel.high,
            rakaatCount: 2,
          ),
          Unit(
            type: UnitType.fardh,
            focusLevel: FocusLevel.high,
            rakaatCount: 2,
          )
        ],
      ),
      Prayer(
        withCongregation: true,
        atMosque: true,
        freshWudhu: false,
        name: 'Dhuhr',
        units: [
          Unit(
            type: UnitType.sunnah,
            focusLevel: FocusLevel.high,
            rakaatCount: 4,
          ),
          Unit(
            type: UnitType.fardh,
            focusLevel: FocusLevel.high,
            rakaatCount: 4,
          ),
          Unit(
            type: UnitType.sunnah,
            focusLevel: FocusLevel.high,
            rakaatCount: 2,
          ),
          Unit(
            type: UnitType.nafl,
            focusLevel: FocusLevel.high,
            rakaatCount: 2,
          ),
        ],
      ),
      Prayer(
        withCongregation: true,
        atMosque: true,
        freshWudhu: false,
        name: "Asr",
        units: [
          Unit(
            type: UnitType.sunnah,
            focusLevel: FocusLevel.high,
            rakaatCount: 4,
          ),
          Unit(
            type: UnitType.fardh,
            focusLevel: FocusLevel.high,
            rakaatCount: 4,
          ),
        ],
      ),
      Prayer(
        withCongregation: true,
        atMosque: true,
        freshWudhu: false,
        name: "Maghrib",
        units: [
          Unit(
            type: UnitType.fardh,
            focusLevel: FocusLevel.high,
            rakaatCount: 3,
          ),
          Unit(
            focusLevel: FocusLevel.high,
            type: UnitType.sunnah,
            rakaatCount: 2,
          ),
          Unit(
            type: UnitType.nafl,
            focusLevel: FocusLevel.high,
            rakaatCount: 2,
          ),
        ],
      ),
      Prayer(
        withCongregation: true,
        atMosque: true,
        freshWudhu: false,
        name: "Isha",
        units: [
          Unit(
            focusLevel: FocusLevel.high,
            type: UnitType.sunnah,
            rakaatCount: 4,
          ),
          Unit(
            focusLevel: FocusLevel.high,
            type: UnitType.fardh,
            rakaatCount: 4,
          ),
          Unit(
            focusLevel: FocusLevel.high,
            type: UnitType.sunnah,
            rakaatCount: 2,
          ),
          Unit(
            focusLevel: FocusLevel.high,
            type: UnitType.witr,
            rakaatCount: 3,
          ),
        ],
      ),
    ];

    // If it is Jumu'ah today, replace 'dhuhr' with 'jumuah'
    if (DateTime.parse(date).weekday == 5) {
      prayers[1] = Prayer(
        withCongregation: true,
        atMosque: true,
        freshWudhu: false,
        name: 'Jumuah',
        units: [
          Unit(
            type: UnitType.sunnah,
            focusLevel: FocusLevel.high,
            rakaatCount: 4,
          ),
          Unit(
            type: UnitType.fardh,
            focusLevel: FocusLevel.high,
            rakaatCount: 2,
          ),
          Unit(
            focusLevel: FocusLevel.high,
            type: UnitType.sunnah,
            rakaatCount: 4,
          ),
          Unit(
            focusLevel: FocusLevel.high,
            type: UnitType.sunnah,
            rakaatCount: 2,
          ),
        ],
      );
    }

    final jsonData = await file.readAsString();
    final content = jsonDecode(jsonData) as Map<String, dynamic>;

    if (!content.containsKey(date)) {
      content[date] = {};
      content[date]["prayers"] = [];

      for (Prayer prayer in prayers) {
        content[date]["prayers"].add(prayer.toJson());
      }

      // Write JSON data to the file
      await file.writeAsString(
        jsonEncode(
          content,
        ),
      );

      return true;
    }

    return false; // 'false' means that the date is already present
  }

  @override
  Future<List<Prayer>> fetchPrayers(String date) async {
    File file = ref.read(databaseFileProvider).requireValue;

    // Read JSON data from the file
    final jsonData = await file.readAsString();

    // Decode JSON string to a map
    final content = jsonDecode(jsonData) as Map<String, dynamic>;

    List<Prayer> prayers = [];

    // Extract prayer object for the date
    final prayersMap = content[date]["prayers"] as List;

    for (var prayerMap in prayersMap) {
      prayers.add(Prayer.fromJson(prayerMap));
    }

    return prayers; // Return the prayers list
  }

  @override
  Future<void> updatePrayer(String date, Prayer prayer, int prayerIndex) async {
    File file = ref.read(databaseFileProvider).requireValue;
    // Read the file and get the data
    final jsonData = await file.readAsString();
    final content = jsonDecode(jsonData) as Map<String, dynamic>;

    // Replace the old Prayer with the new one
    content[date]["prayers"][prayerIndex] = prayer.toJson();

    // Save the data
    file.writeAsString(jsonEncode(content));
  }

  @override
  Future<void> deletePrayers(String date) async {
    File file = ref.read(databaseFileProvider).requireValue;

    // Read JSON data from the file
    final jsonData = await file.readAsString();

    // Decode JSON string to a map
    final prayersMap = jsonDecode(jsonData) as Map<String, dynamic>;

    // Remove prayer data for the date
    prayersMap.remove(date);

    // Encode updated prayers map to JSON string
    final updatedJsonData = jsonEncode(prayersMap);

    // Write updated JSON data back to the file
    await file.writeAsString(updatedJsonData);
  }
}

final prayerRepositoryProvider =
    NotifierProvider<PrayerRepository, void>(PrayerRepository.new);
