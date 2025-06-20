import 'package:todo_app/database/db_heleper.dart';

class TodoModel {
  TodoModel({
    this.id,
    this.title,
    this.category,
    this.createdAt,
    this.isCompleted,
  });
  int? id;
  String? title;
  String? category;
  bool? isCompleted;
  String? createdAt;

  // conversion for getting List of Map data from DB to model class,   Map to model

  factory TodoModel.fromMap(Map<String, dynamic> map) {
    return TodoModel(
        id: map[DbHelper.ID],
        title: map[DbHelper.TITLE],
        category: map[DbHelper.CATEGORY],
        createdAt: map[DbHelper.CREATED_AT],
        isCompleted: map[DbHelper.IS_DONE] == 1);
  }

  // conversion for porviding map data to DB from modal, model to map

  Map<String, dynamic> toMap() {
    return {
      DbHelper.TITLE: title,
      DbHelper.CATEGORY: category,
      DbHelper.CREATED_AT: createdAt,
      DbHelper.IS_DONE: isCompleted == true ? 1 : 0,
    };
  }
}
