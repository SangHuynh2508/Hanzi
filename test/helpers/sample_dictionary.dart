import 'dart:io';

import 'package:doanmonhoc_hanzi/data/db/dictionary_database.dart';
import 'package:drift/native.dart';

/// In-memory dictionary with the 20-word HSK 1 sample loaded.
Future<DictionaryDatabase> openSampleDictionary() async {
  final db = DictionaryDatabase(NativeDatabase.memory());
  final lines = File('test/fixtures/dictionary_sample.sql').readAsLinesSync();
  for (final line in lines) {
    if (line.startsWith('INSERT')) await db.customStatement(line);
  }
  return db;
}
