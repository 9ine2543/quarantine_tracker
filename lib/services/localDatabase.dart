import 'dart:async';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:quarantine_tracker/model/locationLog.dart';

class LocalSQL {
  LocalSQL._();
  static final LocalSQL db = LocalSQL._();
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async {
    return await openDatabase(join(await getDatabasesPath(), 'location_log.db'),
        onCreate: (db, version) {
      return db.execute(
          "CREATE TABLE logs(lat DOUBLE, long DOUBLE, ts DATETIME, status TEXT)");
    }, version: 1);
  }

  Future<void> insert(LocationLog log) async {
    final db = await database;
    await db.insert('logs', log.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> logs() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('logs');
    return maps;
  }

  Future<List<Map<String, dynamic>>> logsByDate(
      int year, int month, int date) async {
    String range = DateFormat('yyyy-MM-dd').format(DateTime(year, month, date));
    final db = await database;
    String query = 'SELECT * FROM logs WHERE date(ts) = \'$range\'';
    print(query);
    final List<Map> list = await db.rawQuery(query);
    return list;
  }
}
