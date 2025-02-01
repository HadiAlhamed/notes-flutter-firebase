import 'package:sqflite/sqflite.dart';

class DbHelper {
  static const String _tableName = "image_paths";
  static const int _version = 1;
  static Database? _db;
  static Future<void> init() async {
    if (_db != null) return;
    String path = "${await getDatabasesPath()}image_paths.db";
    try {
      _db = await openDatabase(
        path,
        version: _version,
        onCreate: (db, version) async {
          await db.execute(
            'CREATE TABLE image_paths ('
            'id INTEGER PRIMARY KEY AUTOINCREMENT,'
            'path TEXT,'
            'userId TEXT)',
          );
        },
      );
      print("database created");
    } catch (e) {
      print("Error creating DataBase $e");
    }
  }

  static Future<int> insert(String userId, String imagePath) async {
    return await _db!.insert(_tableName, {
      'path': imagePath,
      'userId': userId,
    });
  }

  static Future<int> delete(String imagePath) async {
    return await _db!.delete(
      _tableName,
      where: "path = ?",
      whereArgs: [imagePath],
    );
  }

  static Future<int> deleteAll() async {
    return await _db!.delete(
      _tableName,
    );
  }

  static Future<List<Map<String, dynamic>>> query() async {
    print("query function");
    return _db!.query(_tableName);
  }
}
