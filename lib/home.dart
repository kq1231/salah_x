import 'package:flutter/material.dart';
import 'package:salah_x/countdown/prayer_countdown_page.dart';
import 'package:salah_x/features/recording/views/dates_screen.dart';

class PrayerHomePage extends StatelessWidget {
  const PrayerHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.date_range),
            onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const DatesScreen(),
                ),
                (Route<dynamic> route) => false),
          ),
          title: const Text("Prayer Countdown"),
        ),
        body: const PrayerCountdownPage());
  }
}
