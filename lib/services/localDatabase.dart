import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:quarantine_tracker/model/locationLog.dart';

class LocalDatabase {
  LocalDatabase._();
  static final LocalDatabase db = LocalDatabase._();

  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDatabase();
    return _database;
  }

  Future<Database> initDatabase() async {
    return openDatabase(join(await getDatabasesPath(), 'quarantine_tracker.db'),
        onCreate: (db, version) {
      return db.execute(
          "CREATE TABLE logs(id INT NOT NULL AUTO_INCREMENT, citizen_id INT, lat DOUBLE, long DOUBLE, timestamp DATETIME)");
    }, version: 1);
  }

  Future<void> insert(LocationLog log) async {
    final Database db = database as Database;

    await db.insert('logs', log.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> logs() async {
    final Database db = database as Database;

    final List<Map<String, dynamic>> maps = await db.query('logs');
    return maps;
  }
}
