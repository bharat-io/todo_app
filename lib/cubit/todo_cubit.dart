import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/cubit/cubit_state.dart';
import 'package:todo_app/database/db_heleper.dart';
import 'package:todo_app/database/model/todo_model.dart';

class TodoCubit extends Cubit<CubitState> {
  TodoCubit() : super(CubitState(todos: [], todoCount: {}));
  DbHelper dbHelper = DbHelper.getInstance();
  String? _currentCategory; // null means show all

  void fetchAllTodos(String? category) async {
    _currentCategory = category;
    List<TodoModel> allTodos = await dbHelper.fetchTodo(categorName: category);
    Map<String, dynamic> counts = await dbHelper.fetchCounts();
    emit(CubitState(todos: allTodos, todoCount: counts));
    print(state.todoCount);
  }

  void addTodo({required String title, required String categoryText}) async {
    bool isSuccess = await dbHelper.addTodo(
        todoModel: TodoModel(
      title: title,
      category: categoryText,
      createdAt: DateTime.now().toIso8601String(),
    ));
    if (isSuccess) {
      List<TodoModel> allTodos = await dbHelper.fetchTodo();
      Map<String, dynamic> counts = await dbHelper.fetchCounts();

      emit(CubitState(todos: allTodos, todoCount: counts));
    }
  }

  void updateTodo(
      {required String title,
      required int todoId,
      required String categoryText}) async {
    bool isSuccess = await dbHelper.updateTodo(
        todoModel: TodoModel(
      id: todoId,
      title: title,
      category: categoryText,
    ));
    if (isSuccess) {
      List<TodoModel> updatedTodos = await dbHelper.fetchTodo();
      Map<String, dynamic> counts = await dbHelper.fetchCounts();

      emit(CubitState(todos: updatedTodos, todoCount: counts));
    }
  }

  void toggleTodoComletion({required int todId, bool isDone = false}) async {
    bool isSuccess = await dbHelper.isTodoCompleted(
        todoModel: TodoModel(id: todId, isCompleted: isDone));
    if (isSuccess) {
      fetchAllTodos(_currentCategory);
    }
  }

  void deleteTodo({required int todoId}) async {
    bool isSuccess =
        await dbHelper.deleteTodo(todoModel: TodoModel(id: todoId));
    if (isSuccess) {
      List<TodoModel> allTodos = await dbHelper.fetchTodo();
      Map<String, dynamic> counts = await dbHelper.fetchCounts();

      emit(CubitState(todos: allTodos, todoCount: counts));
    }
  }
}
