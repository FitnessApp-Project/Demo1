
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'DateRecorde.dart';
class DateDB {
  static Database? database;

  // Initialize database
  static Future<Database?> initDatabase() async {
    database = await openDatabase(
      // Ensure the path is correctly for any platform
      join(await getDatabasesPath(), "hero_database.db"),
      onCreate: (db, version) {
        return db.execute("CREATE TABLE HEROS("
            "id INTEGER PRIMARY KEY,"
            "name TEXT,"
            "age INTEGER,"
            "ability TEXT"
            ")");
      },

      // Version
      version: 1,
    );

    return database;
  }

  // Check database connected
  static Future<Database?> getDatabaseConnect() async {
    if (database != null) {
      return database;
    } else {
      return await initDatabase();
    }
  }

  // Show all data
  static Future<List<DateRecorde>> showAllData() async {
    final Database? db = await getDatabaseConnect();
    final List<Map<String, dynamic>> maps = await db!.query("HEROS");

    return List.generate(maps.length, (i) {
      return DateRecorde(
        id: maps[i]["id"],
        name: maps[i]["name"],
        age: maps[i]["age"],
       // ability: maps[i]["ability"],
      );
    });
  }

  // Insert
  static Future<void> insertData(DateRecorde date) async {
    final Database? db = await getDatabaseConnect();
    db!.insert(
      "HEROS",
      date.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Update
  static Future<void> updateData(DateRecorde date) async {
    final db = await getDatabaseConnect();
    await db!.update(
      "HEROS",
      date.toMap(),
      where: "id = ?",
      whereArgs: [date.id],
    );
  }

  // Delete
  static Future<void> deleteData(int id) async {
    final db = await getDatabaseConnect();
    await db!.delete(
      "HEROS",
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
