import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/database/model/todo_model.dart';

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
  static const CATEGORY = "category";

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
      $IS_DONE  INTEGER NOT NULL,
      $CATEGORY TEXT NOT NULL
      )

      ''');
    });
  }

  Future<List<TodoModel>> fetchTodo({String? categorName}) async {
    var db = await initDB();
    List<Map<String, dynamic>> todoMapData = [];

    if (categorName != null && categorName.isNotEmpty) {
      todoMapData = await db
          .query(TABLE_NAME, where: "$CATEGORY=?", whereArgs: [categorName]);
    } else {
      todoMapData = await db.query(TABLE_NAME);
    }
    List<TodoModel> todoList = [];
    for (int i = 0; i < todoMapData.length; i++) {
      TodoModel todoModel = TodoModel.fromMap(todoMapData[i]);
      todoList.add(todoModel);
    }
    return todoList;
  }

  Future<bool> addTodo({required TodoModel todoModel}) async {
    var db = await initDB();
    int rowEffected = await db.insert(TABLE_NAME, todoModel.toMap());
    return rowEffected > 0;
  }

  Future<bool> updateTodo({required TodoModel todoModel}) async {
    var db = await initDB();
    int rowEffected = await db.update(
        TABLE_NAME, {TITLE: todoModel.title, CATEGORY: todoModel.category},
        where: "$ID=?", whereArgs: [todoModel.id]);
    return rowEffected > 0;
  }

  Future<bool> isTodoCompleted({required TodoModel todoModel}) async {
    var db = await initDB();
    int rowEffected = await db.update(
        TABLE_NAME, {IS_DONE: todoModel.isCompleted},
        where: "$ID=?", whereArgs: [todoModel.id]);

    return rowEffected > 0;
  }

  Future<bool> deleteTodo({required TodoModel todoModel}) async {
    var db = await initDB();
    int rowEffected = await db.delete(
      TABLE_NAME,
      where: '$ID = ?',
      whereArgs: [todoModel.id],
    );
    return rowEffected > 0;
  }

  Future<Map<String, dynamic>> fetchCounts() async {
    var db = await initDB();
    var allTodoCount = await db.query(TABLE_NAME);

    var businessCount = await db
        .query(TABLE_NAME, where: "$CATEGORY=?", whereArgs: ["business"]);

    var personlCount = await db
        .query(TABLE_NAME, where: "$CATEGORY=?", whereArgs: ["personl"]);

    return {
      "businessCount": businessCount.length,
      "personalCount": personlCount.length,
      "allCount": allTodoCount.length,
    };
  }
}
