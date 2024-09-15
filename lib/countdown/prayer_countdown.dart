import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class PrayerCountdown extends StatefulWidget {
  final List<DateTime>
      prayerTimes; // List of prayer times (Fajr, Dhuhr, Asr, Maghrib, Isha)

  const PrayerCountdown({
    Key? key,
    required this.prayerTimes,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PrayerCountdownState createState() => _PrayerCountdownState();
}

class _PrayerCountdownState extends State<PrayerCountdown>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Duration _timeRemaining;
  late Duration _totalTimeBetweenPrayers;
  late Animation<double> _fadeAnimation;
  double _progress = 0.0;
  DateTime? _previousPrayerTime;
  DateTime? _nextPrayerTime;
  String? _previousPrayerName;
  String? _nextPrayerName;
  late Timer _timer;

  List<String> prayerNames = "Fajr.Dhuhr.Asr.Maghrib.Isha".split(".");

  @override
  void initState() {
    super.initState();
    _determineCurrentPrayerTimes();
    _calculateTimeRemaining();
    _calculateProgress();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: false);

    // Fade animation for seconds part
    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(_controller);

    // Schedule updates to the timer every second
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeRemaining.inSeconds <= 0) {
        setState(() {
          _determineCurrentPrayerTimes(); // Recalculate the next prayer when time runs out
        });
      }
      setState(() {
        _calculateTimeRemaining();
        _calculateProgress();
        _controller.forward(from: 0); // Restart fade effect for seconds
      });
    });
  }

  // Determine the next and previous prayer times based on the current time
  void _determineCurrentPrayerTimes() {
    DateTime now = DateTime.now();
    widget.prayerTimes.sort(); // Ensure the list is sorted
    for (int i = 0; i < widget.prayerTimes.length; i++) {
      if (widget.prayerTimes[i].isAfter(now)) {
        _previousPrayerTime = i == 0
            ? widget.prayerTimes.last
                .subtract(const Duration(days: 1)) // Previous day for Fajr
            : widget.prayerTimes[i - 1];
        _nextPrayerTime = widget.prayerTimes[i];
        _previousPrayerName = i == 0 ? prayerNames.last : prayerNames[i - 1];
        _nextPrayerName = prayerNames[i];
        break;
      }
    }
    // If no next prayer found (we're past Isha), set next prayer to Fajr of next day
    if (_nextPrayerTime == null) {
      _previousPrayerTime = widget.prayerTimes.last;
      _nextPrayerTime = widget.prayerTimes.first.add(const Duration(days: 1));
      _previousPrayerName = prayerNames.last;
      _nextPrayerName = prayerNames.first;
    }
  }

  // Calculate the difference between current time and next prayer
  void _calculateTimeRemaining() {
    final now = DateTime.now();
    if (_nextPrayerTime != null && _nextPrayerTime!.isAfter(now)) {
      _timeRemaining = _nextPrayerTime!.difference(now);
    } else {
      _timeRemaining = Duration.zero;
    }

    if (_previousPrayerTime != null) {
      _totalTimeBetweenPrayers =
          _nextPrayerTime!.difference(_previousPrayerTime!);
    }
  }

  // Calculate progress toward the next prayer
  void _calculateProgress() {
    final timePassed =
        DateTime.now().difference(_previousPrayerTime!).inSeconds;
    final totalTime = _totalTimeBetweenPrayers.inSeconds;
    _progress = (timePassed / totalTime)
        .clamp(0.0, 1.0); // Ensure progress stays between 0 and 1
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  String _formatHoursMinutes(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours.remainder(24));
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    return "$hours:$minutes";
  }

  String _formatSeconds(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return twoDigits(duration.inSeconds.remainder(60));
  }

  @override
  Widget build(BuildContext context) {
    print("BUID");
    return Column(
      children: [
        const Spacer(), // Semi-circle outline progress bar with prayer names
        Column(
          children: [
            CustomPaint(
              size: const Size(200, 100),
              painter: SemiCirclePainter(
                progress: _progress,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: 200 + 28,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_previousPrayerName!,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w300)),
              Text(_nextPrayerName!,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w300)),
            ],
          ),
        ),
        SizedBox(
          width: 200 + 28,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(TimeOfDay.fromDateTime(_previousPrayerTime!).format(context),
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w300)),
              Text(TimeOfDay.fromDateTime(_nextPrayerTime!).format(context),
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w300)),
            ],
          ),
        ),

        const Spacer(
          flex: 2,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _formatHoursMinutes(_timeRemaining),
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            const Text(
              ":",
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            FadeTransition(
              opacity: _fadeAnimation,
              child: Text(
                _formatSeconds(_timeRemaining),
                style:
                    const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const Spacer(
          flex: 2,
        ),
      ],
    );
  }
}

class SemiCirclePainter extends CustomPainter {
  final double progress;

  SemiCirclePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    // Define the base paint for the outline
    final Paint outlinePaint = Paint()
      ..color = Colors.white // Outline color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20 // Slightly wider stroke width for the outline
      ..strokeCap = StrokeCap.round;

    // Base paint for the background semi-circle
    final Paint backgroundPaint = Paint()
      ..color = Colors.green // Background color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 13
      ..strokeCap = StrokeCap.round;

    // Paint for the progress arc
    final Paint progressPaint = Paint()
      ..color = Colors.red // Progress arc color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15
      ..strokeCap = StrokeCap.round;

    // Define the rectangle for the semi-circle arc
    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height * 2);

    // Draw the background semi-circle
    canvas.drawArc(rect, pi, pi, false, backgroundPaint);

    // Draw the outline for the progress arc
    canvas.drawArc(rect, pi, pi * progress, false, outlinePaint);

    // Draw the progress semi-circle
    canvas.drawArc(rect, pi, pi * progress, false, progressPaint);
  }

  @override
  bool shouldRepaint(SemiCirclePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
