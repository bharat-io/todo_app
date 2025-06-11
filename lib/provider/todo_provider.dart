import 'package:flutter/material.dart';
import 'package:todo_app/database/db_heleper.dart';

class TodoProvider extends ChangeNotifier {
  DbHelper dbHelper = DbHelper.getInstance();
  List<Map<String, dynamic>> _todos = [];
  List<Map<String, dynamic>> getTodos() => _todos;

  void fetchTodos() async {
    _todos = await dbHelper.fetchTodo();
    notifyListeners();
  }

  void isCompleted({required int todId, required isChecked}) async {
    await dbHelper.isTodoCompleted(id: todId, isDone: isChecked);
    fetchTodos();
  }

  void addTodos({required String title}) async {
    await dbHelper.addTodo(title);
    fetchTodos();
  }

  void updateTodos({required int todId, required String todotitle}) async {
    await dbHelper.updateTodo(id: todId, title: todotitle);

    fetchTodos();
  }

  void deleteTodos({required int todoId}) async {
    await dbHelper.deleteTodo(todoId);
    fetchTodos();
  }
}
