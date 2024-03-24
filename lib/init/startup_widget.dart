import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:salah_x/features/recording/views/dates_screen.dart';
import 'package:salah_x/init/startup_provider.dart';

class StartupScreen extends ConsumerWidget {
  const StartupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final startupState = ref.watch(startupProvider);

    return startupState.when(
      data: (data) {
        return const Scaffold(body: DatesScreen());
      },
      error: (e, st) {
        return const Scaffold(body: Text("ERROR"));
      },
      loading: () {
        return Scaffold(
          body: SpinKitCircle(
            color: Theme.of(context).colorScheme.primary,
          ),
        );
      },
    );
  }
}
