import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final prayerTimingsProvider = FutureProvider<List<TimeOfDay>>((ref) async {
  final url = Uri.parse(
      "http://api.aladhan.com/v1/timingsByCity?city=Karachi&country=Pakistan&school=1&method=1");
  List<TimeOfDay> timings = [];

  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      for (String prayer in "Fajr,Sunrise,Dhuhr,Asr,Maghrib,Isha".split(",")) {
        List time = json["data"]["timings"][prayer]
            .split(":")
            .map((e) => int.parse(e))
            .toList();
        timings.add(TimeOfDay(hour: time.first, minute: time.last));
      }
      return timings;
    }
  } catch (e) {
    return [
      // for (int _ in Iterable.generate(5)) const TimeOfDay(hour: 0, minute: 0)
    ];
  }
  return [];
});
