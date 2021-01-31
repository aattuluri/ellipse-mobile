import 'dart:async';
import 'dart:io';

import 'package:EllipseApp/models/index.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sql.dart';

import '../models/index.dart';

class DatabaseProvider {
  DatabaseProvider._();

  static final DatabaseProvider db = DatabaseProvider._();
  Database _database;
  static final _databaseName = "database.db";
  static final _databaseVersion = 1;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await getDatabaseInstance();
    return _database;
  }

  Future<Database> getDatabaseInstance() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  void _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE Users ("
        "id integer primary key AUTOINCREMENT,"
        "name TEXT,"
        "email TEXT,"
        "userId TEXT,"
        "username TEXT,"
        "gender TEXT,"
        "profilePic TEXT,"
        "collegeId TEXT,"
        "collegeName TEXT,"
        "bio TEXT,"
        "designation TEXT"
        ")");
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) async {}

  Future<UserDetails> fetchUser(int id) async {
    final db = await database;
    var response = await db.query("Users", where: "id = ?", whereArgs: [id]);
    return response.isNotEmpty ? UserDetails().fromMap(response.first) : null;
  }

  addUser(UserDetails data) async {
    final db = await database;
    var raw = await db.insert(
      "Users",
      data.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return raw;
  }

  Future<int> removeUser(int id) async {
    final db = await database;
    return await db.delete("Users", where: "id = ?", whereArgs: [id]);
  }

  Future<void> clearUsers() async {
    final db = await database;
    return await db.rawQuery("DELETE FROM Users");
  }
}
