import 'package:todo_app/database/model/todo_model.dart';

class CubitState {
  CubitState({required this.todos, required this.todoCount});
  List<TodoModel> todos;
  Map<String, dynamic> todoCount;
}
