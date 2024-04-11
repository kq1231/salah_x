import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salah_x/init/database_file_provider.dart';

final startupProvider = FutureProvider<void>((ref) async {
  ref.onDispose(() {
    // In case any provider fails, refresh it
    ref.invalidate(databaseFileProvider);
  });

  await ref.read(databaseFileProvider.future);
});
