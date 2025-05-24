import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbHeleper {
  DbHeleper._();
  static DbHeleper getInstance() {
    return DbHeleper._();
  }

  static const DB_NAME = "todo.db";
  static const TABLE_NAME = "todo_table";
  static const ID = "id";
  static const CREATED_AT = "created_at";
  static const TITLE = "title";
  static const DESCRIPTION = "description";

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
    String path = join(appDir.path, DB_NAME);
    return openDatabase(
      path,
      version: 1,
      onCreate: (Database db, version) {
        db.execute('''CREATE TABLE $TABLE_NAME(
        $ID INTEGER PRIMARY AUTOICREMENT,
        $CREATED_AT TEXT NOT NULL,
        $TITLE TEXT NOT NULL,
        $DESCRIPTION TEXT NOT NULL
        )
''');
      },
    );
  }

  void fetchTodo() {}
  void addTodo() {}
  void updateTodo() {}
  void deleteTodo() {}
}
