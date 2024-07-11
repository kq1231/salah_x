import 'package:flutter/material.dart';
import 'package:salah_x/features/recording/views/prayer_recording_screen.dart';

class PrayerHomePage extends StatelessWidget {
  const PrayerHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    String date = DateTime.now().toString().substring(0, 10);

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Salah X",
            style: TextStyle(fontWeight: FontWeight.w100),
          ),
        ),
        body: PrayerRecordingScreen(date: date));
  }
}
