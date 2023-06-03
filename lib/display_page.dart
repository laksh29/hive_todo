import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive/hive.dart';
import 'package:todo_river/db.dart';
import 'package:todo_river/style.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final myBox = Hive.box("Todo");
  TodoDatabase todoDB = TodoDatabase();
  late TextEditingController titleCont;
  late TextEditingController descriptionCont;
  // late List displayList;

  @override
  void initState() {
    if (myBox.get("Todo") == null) {
      todoDB.initialData();
    } else {
      todoDB.loadData();
    }

    titleCont = TextEditingController();
    descriptionCont = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    titleCont.dispose();
    descriptionCont.dispose();
    super.dispose();
  }

  void addTodo() {
    showDialog(
      context: context,
      builder: (context) {
        return MyDialogBox(
          titleCont: titleCont,
          descriptionCont: descriptionCont,
          save: save,
          cancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  void toggle(bool? value, int index) {
    setState(() {
      todoDB.todoList[index][2] = !todoDB.todoList[index][2];
    });
    todoDB.add();
  }

  void save() {
    setState(() {
      todoDB.todoList.add([
        titleCont.text,
        descriptionCont.text,
        false,
      ]);
      titleCont.clear();
      descriptionCont.clear();
    });
    Navigator.of(context).pop();
    todoDB.add();
  }

  void cancel() {
    Navigator.of(context).pop();
    titleCont.clear();
    descriptionCont.clear();
  }

  void delete(int index) {
    setState(() {
      todoDB.todoList.removeAt(index);
    });
    todoDB.add();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: const Text("River TO-Do")),
      body: ListView.builder(
        itemCount: todoDB.todoList.length,
        itemBuilder: (context, index) {
          return TodoTile(
            width: width,
            index: index,
            db: todoDB,
            onToggle: (value) => toggle(value, index),
            delete: (context) => delete(index),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addTodo,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class MyTextField extends StatelessWidget {
  const MyTextField({
    super.key,
    required this.cont,
    required this.text,
  });

  final TextEditingController cont;
  final String text;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: cont,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: text,
      ),
    );
  }
}

class TodoTile extends StatelessWidget {
  TodoTile({
    super.key,
    required this.width,
    required this.index,
    required this.db,
    required this.onToggle,
    required this.delete,
  });

  final double width;
  final int index;
  final TodoDatabase db;
  Function(bool?)? onToggle;
  Function(BuildContext) delete;

  @override
  Widget build(BuildContext context) {
    bool taskStatus = db.todoList[index][2];
    return Slidable(
      endActionPane: ActionPane(
        motion: StretchMotion(),
        children: [
          SlidableAction(
            onPressed: delete,
            icon: Icons.delete,
            backgroundColor: Colors.red.shade300,
            borderRadius: BorderRadius.circular(12),
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 10.0,
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 10.0,
        ),
        width: width,
        decoration: BoxDecoration(
            border: Border.all(), borderRadius: BorderRadius.circular(15)),
        child: Row(
          children: [
            Checkbox(value: taskStatus, onChanged: onToggle),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  db.todoList[index][0],
                  style: taskStatus ? doneTitle : notDoneTitle,
                ),
                Text(
                  db.todoList[index][1] ?? "",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MyButton extends StatelessWidget {
  MyButton({
    super.key,
    required this.text,
    required this.onPressed,
  });
  final String text;
  VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }
}

class MyDialogBox extends StatelessWidget {
  MyDialogBox({
    super.key,
    required this.titleCont,
    required this.descriptionCont,
    required this.save,
    required this.cancel,
  });
  final TextEditingController titleCont;
  final TextEditingController descriptionCont;
  VoidCallback save;
  VoidCallback cancel;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MyTextField(
            cont: titleCont,
            text: "Add a new task title",
          ),
          const SizedBox(height: 10),
          MyTextField(
            cont: descriptionCont,
            text: "Describe your task (optional)",
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              MyButton(text: "Save", onPressed: save),
              const SizedBox(width: 10),
              MyButton(text: "Cancel", onPressed: cancel)
            ],
          )
        ],
      ),
    );
  }
}
