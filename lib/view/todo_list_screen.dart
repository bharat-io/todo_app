import 'package:flutter/material.dart';
import 'package:todo_app/db_heleper.dart';
import 'package:todo_app/show_modal_sheet.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final TextEditingController titleController = TextEditingController();
  late final DbHelper dbHelper;
  List<Map<String, dynamic>> todos = [];

  static const Color backgroundColor = Color(0xff344FA1);
  static const Color lightBlue = Color(0xffA1C0F8);
  static const Color cardColor = Color(0xff031956);
  static const Color accentColor = Color(0xffEB05FF);

  @override
  void initState() {
    super.initState();
    dbHelper = DbHelper.getInstance();
    fetchTodos();
  }

  Future<void> fetchTodos() async {
    todos = await dbHelper.fetchTodo();
    setState(() {});
  }

  void _showTodoBottomSheet({
    required String titleText,
    required String buttonText,
    required VoidCallback onTap,
  }) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (_) {
        return buildBottomSheet(
          context,
          onTap: onTap,
          titleController: titleController,
          titleText: titleText,
          buttonText: buttonText,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
            Expanded(
              child: ListView.builder(
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  final todo = todos[index];
                  return _buildTodoItem(
                    title: todo[DbHelper.TITLE],
                    onEdit: () {
                      titleController.text = todo[DbHelper.TITLE].toString();
                      _showTodoBottomSheet(
                        titleText: "Update",
                        buttonText: "Update",
                        onTap: () async {
                          await dbHelper.updateTodo(
                            id: todo[DbHelper.ID],
                            title: titleController.text,
                          );
                          fetchTodos();
                          Navigator.pop(context);
                        },
                      );
                    },
                    onDelete: () async {
                      await dbHelper.deleteTodo(todo[DbHelper.ID]);
                      fetchTodos();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: accentColor,
        shape: const CircleBorder(),
        onPressed: () {
          titleController.clear();
          _showTodoBottomSheet(
            titleText: "Add",
            buttonText: "Add",
            onTap: () async {
              await dbHelper.addTodo(titleController.text);
              fetchTodos();
              Navigator.pop(context);
            },
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildCategoryWidgets() {
    Widget _categoryCard(String label) => Container(
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
        _categoryCard("Business"),
        const SizedBox(width: 8),
        _categoryCard("Personal"),
      ],
    );
  }

  Widget _buildTodoItem({
    required String title,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
  }) {
    return ListTile(
      leading: Checkbox(
        value: false,
        onChanged: (_) {},
        shape: const CircleBorder(),
        activeColor: lightBlue,
        checkColor: cardColor,
        side: const BorderSide(color: accentColor, width: 2),
      ),
      title: Text(title, style: const TextStyle(color: lightBlue)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
              icon: const Icon(Icons.edit, color: lightBlue),
              onPressed: onEdit),
          IconButton(
              icon: const Icon(Icons.delete, color: accentColor),
              onPressed: onDelete),
        ],
      ),
    );
  }
}
