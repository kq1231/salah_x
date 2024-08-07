import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:salah_x/objectbox.g.dart';
import 'package:path/path.dart' as p;

final storeProvider = FutureProvider<Store>((ref) async {
  final docsDir = await getApplicationDocumentsDirectory();
  final store = await openStore(directory: p.join(docsDir.path, "prayers"));
  return store;
});
