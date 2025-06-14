import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  DbHelper._();

  static DbHelper getInstance() {
    return DbHelper._();
  }

  static const DB_NAME = "todo.db";
  static const TABLE_NAME = "todo_table";
  static const ID = "id";
  static const CREATED_AT = "created_at";
  static const TITLE = "title";
  static const IS_DONE = "is_done";

  Database? database;

  Future<Database> initDB() async {
    if (database == null) {
      database = await openDB();
      return database!;
    } else {
      return database!;
    }
  }

  Future<Database> openDB() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String dbpath = join(appDir.path, DB_NAME);
    return openDatabase(dbpath, version: 1,
        onCreate: (Database db, int version) {
      return db.execute('''
      CREATE TABLE $TABLE_NAME(
      $ID INTEGER PRIMARY KEY AUTOINCREMENT,
      $CREATED_AT Text NOT NULL,
      $TITLE TEXT NOT NULL,
      $IS_DONE  INTEGER NOT NULL
      
      )

      ''');
    });
  }

  Future<List<Map<String, dynamic>>> fetchTodo() async {
    var db = await initDB();
    return await db.query(TABLE_NAME);
  }

  Future<bool> addTodo(String title) async {
    var db = await initDB();
    int rowEffected = await db.insert(
      TABLE_NAME,
      {
        TITLE: title,
        CREATED_AT: DateTime.now().toIso8601String(),
        IS_DONE: 0,
      },
    );
    return rowEffected > 0;
  }

  Future<bool> updateTodo({required int id, required String title}) async {
    var db = await initDB();
    int rowEffected = await db.update(TABLE_NAME, {TITLE: title},
        where: "$ID=?", whereArgs: [id]);
    return rowEffected > 0;
  }

  Future<bool> isTodoCompleted({required int id, required bool isDone}) async {
    var db = await initDB();
    int rowEffected = await db.update(TABLE_NAME, {IS_DONE: isDone ? 1 : 0},
        where: "$ID=?", whereArgs: [id]);

    return rowEffected > 0;
  }

  Future<bool> deleteTodo(int id) async {
    var db = await initDB();
    int rowEffected = await db.delete(
      TABLE_NAME,
      where: '$ID = ?',
      whereArgs: [id],
    );
    return rowEffected > 0;
  }
}
