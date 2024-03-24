import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

final databaseFileProvider = FutureProvider<File>((ref) async {
  String filePath = (await getApplicationDocumentsDirectory()).path;

  File databaseFile = File("$filePath/prayers.db.json");

  if (!await databaseFile.exists()) {
    await databaseFile.create();
    await databaseFile.writeAsString("{}");
  }
  return databaseFile;
});
