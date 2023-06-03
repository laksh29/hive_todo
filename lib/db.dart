import 'package:hive/hive.dart';

class TodoDatabase {
  final myBox = Hive.box("Todo");

  List todoList = [];

  void initialData() {
    todoList = [
      [
        "Play BasketBall",
        null,
        false,
      ],
      [
        "Complete ToDo application",
        null,
        false,
      ],
      [
        "Complete Internship Assignment",
        "Figma to code + firebase for auth",
        false,
      ]
    ];
  }

  // get data
  void loadData() {
    todoList = myBox.get('Todo');
  }

  // add data to db
  void add() {
    myBox.put('TodoList', todoList);
  }
}
