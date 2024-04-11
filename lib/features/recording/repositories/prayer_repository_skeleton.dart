import 'package:salah_x/features/recording/models/prayer.dart';

abstract class PrayerRepositorySkeleton {
  Future<Map<int, Map<int, List<int>>>> getDates();
  Future<bool> createPrayers(String date);
  Future<List<Prayer>> fetchPrayers(String date);
  Future<void> updatePrayer(String date, Prayer prayer, int prayerIndex);
  Future<void> deletePrayers(String date);

  // TODO In Shaa Allaah:
  // createPrayer(Prayer prayer)
  // updatePrayers(List<Prayer> prayers)
}
