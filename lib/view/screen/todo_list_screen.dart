import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:todo_app/cubit/cubit_state.dart';
import 'package:todo_app/cubit/todo_cubit.dart';
import 'package:todo_app/database/db_heleper.dart';
import 'package:todo_app/view/widgets/show_modal_sheet.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final TextEditingController titleController = TextEditingController();
  late final DbHelper dbHelper;
  List<Map<String, dynamic>> todosList = [];

  final dateTime = DateFormat('EEEE, d MMMM ');

  static const Color backgroundColor = Color(0xff344FA1);
  static const Color lightBlue = Color(0xffA1C0F8);
  static const Color cardColor = Color(0xff031956);
  static const Color accentColor = Color(0xffEB05FF);

  @override
  void initState() {
    super.initState();
    dbHelper = DbHelper.getInstance();
    context.read<TodoCubit>().fetchAllTodos("");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Icon(Icons.menu, color: lightBlue),
        actions: const [
          Icon(
            Icons.search,
            color: lightBlue,
          ),
          SizedBox(width: 12),
          Padding(
            padding: EdgeInsets.only(right: 12.0),
            child: Icon(
              Icons.notifications,
              color: lightBlue,
            ),
          )
        ],
      ),
      body: BlocBuilder<TodoCubit, CubitState>(builder: (context, state) {
        final todosList = state.todos;
        final todoCount = state.todoCount ?? {};

        return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15).copyWith(top: 20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text("What's up, Bharat!",
                  style: TextStyle(fontSize: 35, color: lightBlue)),
              const SizedBox(height: 20),
              const Text("CATEGORIES",
                  style: TextStyle(fontSize: 16, color: lightBlue)),
              const SizedBox(height: 20),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: _buildCategoryWidgets(
                  onBusinessTap: () {
                    context.read<TodoCubit>().fetchAllTodos("business");
                  },
                  onPersonalTap: () {
                    context.read<TodoCubit>().fetchAllTodos("personl");
                  },
                  onTapAll: () {
                    context.read<TodoCubit>().fetchAllTodos("");
                  },
                  bussinesCount: (todoCount["businessCount"] ?? 0).toString(),
                  personlCount: (todoCount["personalCount"] ?? 0).toString(),
                  allCount: (todoCount["allCount"] ?? 0).toString(),
                ),
              ),
              const SizedBox(height: 20),
              const Text("TODAY'S TASKS",
                  style: TextStyle(fontSize: 16, color: lightBlue)),
              Expanded(
                  child: todosList.isNotEmpty
                      ? ListView.builder(
                          itemCount: todosList.length,
                          itemBuilder: (context, index) {
                            final todo = todosList[index];
                            return _buildTodoItem(
                              isChecked: todo.isCompleted == true,
                              onChanged: (value) async {
                                context.read<TodoCubit>().toggleTodoComletion(
                                      todId: todo.id!,
                                      isDone: value!,
                                    );
                              },
                              title: todo.title!,
                              dateTime: dateTime
                                  .format(DateTime.parse(todo.createdAt!)),
                              onEdit: () {
                                titleController.text = todo.title.toString();

                                showModalBottomSheet(
                                  backgroundColor: Colors.transparent,
                                  isScrollControlled: true,
                                  context: context,
                                  builder: (_) => TodoFormBottomSheet(
                                    title: " Update-todo-detail!",
                                    titleController: titleController,
                                    initialCategory: "personl",
                                    onSave: (title, category) {
                                      context.read<TodoCubit>().updateTodo(
                                          todoId: todo.id!,
                                          title: title,
                                          categoryText: category);
                                    },
                                  ),
                                );
                              },
                              onDelete: () async {
                                context
                                    .read<TodoCubit>()
                                    .deleteTodo(todoId: todo.id!);
                              },
                            );
                          },
                        )
                      : Center(
                          child: Text(
                            "You dont have any todo.!",
                            style: TextStyle(fontSize: 12, color: lightBlue),
                          ),
                        ))
            ]));
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: accentColor,
        shape: const CircleBorder(),
        onPressed: () {
          titleController.clear();
          showModalBottomSheet(
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
            context: context,
            builder: (_) => TodoFormBottomSheet(
              title: " todo-detail!",
              titleController: titleController,
              initialCategory: "personl",
              onSave: (title, category) {
                context
                    .read<TodoCubit>()
                    .addTodo(title: title, categoryText: category);
              },
            ),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildCategoryWidgets({
    required Function onBusinessTap,
    required Function onPersonalTap,
    required Function onTapAll,
    required String bussinesCount,
    required String personlCount,
    required String allCount,
  }) {
    Widget categoryCard(
      String label, {
      required String count,
    }) =>
        Container(
          padding: const EdgeInsets.all(12),
          width: 140,
          height: 100,
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: const Offset(0, 4),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("$count tasks",
                  style: TextStyle(fontSize: 14, color: lightBlue)),
              const SizedBox(height: 4),
              Text(label,
                  style: const TextStyle(fontSize: 26, color: lightBlue)),
              const SizedBox(height: 4),
              const Divider(color: lightBlue),
            ],
          ),
        );

    return Row(
      children: [
        InkWell(
            onTap: () {
              onBusinessTap();
            },
            child: categoryCard("Business", count: bussinesCount)),
        const SizedBox(width: 8),
        InkWell(
            onTap: () {
              onPersonalTap();
            },
            child: categoryCard("Personal", count: personlCount)),
        const SizedBox(width: 8),
        InkWell(
            onTap: () {
              onTapAll();
            },
            child: categoryCard("All", count: allCount)),
      ],
    );
  }

  Widget _buildTodoItem({
    required String title,
    required String dateTime,
    required bool isChecked,
    required ValueChanged<bool?> onChanged,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
  }) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      width: double.infinity,
      height: 65,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Checkbox(
            value: isChecked,
            onChanged: onChanged,
            shape: const CircleBorder(),
            activeColor: lightBlue,
            checkColor: cardColor,
            side: const BorderSide(color: accentColor, width: 2),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 20,
                    color: lightBlue,
                    decoration: isChecked
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    decorationColor: lightBlue,
                    decorationThickness: 2,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  dateTime,
                  style: TextStyle(fontSize: 10, color: lightBlue),
                )
              ],
            ),
          ),
          IconButton(
              onPressed: () {
                onEdit();
              },
              icon: Icon(
                Icons.edit,
                color: lightBlue,
              )),
          IconButton(
              onPressed: () {
                onDelete();
              },
              icon: Icon(
                Icons.delete,
                color: accentColor,
              ))
        ],
      ),
    );
  }
}
