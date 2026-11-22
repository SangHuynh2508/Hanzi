import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'dictionary_database.g.dart';

/// Bump when assets/dictionary.sqlite is rebuilt, so installed apps copy the
/// new file instead of keeping the old one.
const int kDictionaryBuild = 1;

typedef DictionaryOpener = Future<DictionaryDatabase> Function(
  void Function(double progress) onProgress,
);

/// Read-only dictionary shipped in assets (spec §6). Never synced.
@DriftDatabase(include: {'dictionary.drift'})
class DictionaryDatabase extends _$DictionaryDatabase {
  DictionaryDatabase(super.e);

  /// Must equal the PRAGMA user_version written by the Python builder.
  @override
  int get schemaVersion => 1;

  /// Copies the asset to app storage on first run (or when [kDictionaryBuild]
  /// changes), reporting progress 0..1, then opens it.
  static Future<DictionaryDatabase> openFromAssets(
    void Function(double progress) onProgress,
  ) async {
    final dir = await getApplicationSupportDirectory();
    final file = File(p.join(dir.path, 'dictionary.sqlite'));
    final marker = File(p.join(dir.path, 'dictionary.build'));
    final upToDate = file.existsSync() &&
        marker.existsSync() &&
        marker.readAsStringSync() == '$kDictionaryBuild';
    if (!upToDate) {
      final data = await rootBundle.load('assets/dictionary.sqlite');
      await copyWithProgress(data.buffer.asUint8List(), file, onProgress);
      marker.writeAsStringSync('$kDictionaryBuild');
    }
    onProgress(1);
    return DictionaryDatabase(NativeDatabase.createInBackground(file));
  }
}

Future<void> copyWithProgress(
  Uint8List bytes,
  File target,
  void Function(double progress) onProgress, {
  int chunkSize = 1 << 20,
}) async {
  final sink = target.openWrite();
  for (var start = 0; start < bytes.length; start += chunkSize) {
    final end = (start + chunkSize).clamp(0, bytes.length);
    sink.add(bytes.sublist(start, end));
    onProgress(end / bytes.length);
  }
  await sink.close();
}
