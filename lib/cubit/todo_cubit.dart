import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/cubit/cubit_state.dart';
import 'package:todo_app/database/db_heleper.dart';

class TodoCubit extends Cubit<CubitState> {
  TodoCubit() : super(CubitState(todos: []));
  DbHelper dbHelper = DbHelper.getInstance();

  void fetchAllTodos() async {
    List<Map<String, dynamic>> allStudents = await dbHelper.fetchTodo();
    emit(CubitState(todos: allStudents));
  }

  void addTodo({required String title}) async {
    bool isSuccess = await dbHelper.addTodo(title);
    if (isSuccess) {
      fetchAllTodos();
    }
  }

  void updateTodo({required String title, required int todoId}) async {
    bool isSuccess = await dbHelper.updateTodo(id: todoId, title: title);
    if (isSuccess) {
      fetchAllTodos();
    }
  }

  void toggleTodoComletion({required int todId, bool isDone = false}) async {
    bool isSuccess = await dbHelper.isTodoCompleted(id: todId, isDone: isDone);
    if (isSuccess) {
      fetchAllTodos();
    }
  }

  void deleteTodo({required int todoId}) async {
    bool isSuccess = await dbHelper.deleteTodo(todoId);
    if (isSuccess) {
      fetchAllTodos();
    }
  }
}
