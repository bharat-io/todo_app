import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/database/db_heleper.dart';
import 'package:todo_app/provider/todo_provider.dart';
import 'package:todo_app/view/widgets/show_modal_sheet.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final TextEditingController titleController = TextEditingController();
  late final DbHelper dbHelper;
  List<Map<String, dynamic>> todos = [];

  final dateTime = DateFormat('EEEE, d MMMM ');

  static const Color backgroundColor = Color(0xff344FA1);
  static const Color lightBlue = Color(0xffA1C0F8);
  static const Color cardColor = Color(0xff031956);
  static const Color accentColor = Color(0xffEB05FF);

  @override
  void initState() {
    super.initState();
    dbHelper = DbHelper.getInstance();
    context.read<TodoProvider>().fetchTodos();
  }

  void _showTodoBottomSheet({
    required String titleText,
    required String buttonText,
    required VoidCallback onTap,
  }) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (_) {
        return Container(
          margin: EdgeInsets.all(15),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    lightBlue,
                    backgroundColor,
                  ],
                  stops: [
                    0.5,
                    1.0
                  ])),
          child: buildBottomSheet(
            context,
            onTap: onTap,
            titleController: titleController,
            titleText: titleText,
            buttonText: buttonText,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print("------------------------Rebuilding--------------");
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Icon(Icons.menu, color: lightBlue),
        actions: const [
          Icon(Icons.search, color: lightBlue),
          SizedBox(width: 12),
          Padding(
            padding: EdgeInsets.only(right: 12.0),
            child: Icon(Icons.notifications, color: lightBlue),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15).copyWith(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("What's up, Bharat!",
                style: TextStyle(fontSize: 35, color: lightBlue)),
            const SizedBox(height: 20),
            const Text("CATEGORIES",
                style: TextStyle(fontSize: 16, color: lightBlue)),
            const SizedBox(height: 20),
            _buildCategoryWidgets(),
            const SizedBox(height: 20),
            const Text("TODAY'S TASKS",
                style: TextStyle(fontSize: 16, color: lightBlue)),
            const SizedBox(height: 20),
            Consumer(builder: (ctx, provider, __) {
              todos = ctx.watch<TodoProvider>().getTodos();
              return Expanded(
                  child: todos.isNotEmpty
                      ? ListView.builder(
                          itemCount: todos.length,
                          itemBuilder: (context, index) {
                            final todo = todos[index];
                            return _buildTodoItem(
                              isChecked: todo[DbHelper.IS_DONE] == 1,
                              onChanged: (newValue) async {
                                context.read<TodoProvider>().updateTodos(
                                    todId: todo[DbHelper.ID],
                                    todotitle: todo[DbHelper.TITLE],
                                    isDone: newValue ?? false);
                              },
                              title: todo[DbHelper.TITLE],
                              dateTime: dateTime.format(
                                  DateTime.parse(todo[DbHelper.CREATED_AT])),
                              onEdit: () {
                                titleController.text =
                                    todo[DbHelper.TITLE].toString();
                                _showTodoBottomSheet(
                                  titleText: "Update Todo.!",
                                  buttonText: "Update",
                                  onTap: () {
                                    context.read<TodoProvider>().updateTodos(
                                        todId: todo[DbHelper.ID],
                                        todotitle: titleController.text);

                                    Navigator.pop(context);
                                  },
                                );
                              },
                              onDelete: () async {
                                context
                                    .read<TodoProvider>()
                                    .deleteTodos(todoId: todo[DbHelper.ID]);
                              },
                            );
                          },
                        )
                      : Center(
                          child: Text(
                            "You dont have any todo.!",
                            style: TextStyle(fontSize: 12, color: lightBlue),
                          ),
                        ));
            })
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: accentColor,
        shape: const CircleBorder(),
        onPressed: () {
          titleController.clear();
          _showTodoBottomSheet(
            titleText: "Add Todo.!",
            buttonText: "save",
            onTap: () async {
              context
                  .read<TodoProvider>()
                  .addTodos(title: titleController.text);
              // await dbHelper.addTodo(titleController.text);

              Navigator.of(context).pop();
            },
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildCategoryWidgets() {
    Widget categoryCard(String label) => Container(
          padding: const EdgeInsets.all(12),
          width: 161,
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
              const Text("40 tasks",
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
        categoryCard("Business"),
        const SizedBox(width: 8),
        categoryCard("Personal"),
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
