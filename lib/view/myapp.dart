import 'package:flutter/material.dart';

import '../data/database_helper.dart';
import '../model/model.dart';
import '../widgets/tdList.dart';

class MyApp extends StatefulWidget {
  final DatabaseHelper databaseHelper;
  const MyApp({super.key, required this.databaseHelper});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  final GlobalKey<TodoListState> _todoListKey = GlobalKey<TodoListState>();
  void refreshTodoList() {
    _todoListKey.currentState?.refreshTodoList();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TODO APP',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightGreenAccent,
          title: const Text(
            "TODO APP",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: TodoList(
          key: _todoListKey,
          databaseHelper: widget.databaseHelper,
          refreshCallBack: refreshTodoList,
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(
            Icons.add,
            fill: 1,
          ),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  final TextEditingController controller =
                      TextEditingController();
                  return AlertDialog(
                    title: const Text("Add Todo"),
                    content: TextField(
                      controller: controller,
                      autofocus: false,
                      decoration: const InputDecoration(labelText: 'Todo'),
                    ),
                    actions: [
                      TextButton(
                          onPressed: () async {
                            final newTodo =
                                Todo(title: controller.text, isCompleted: 1);
                            await widget.databaseHelper.insertTodo(newTodo);
                            controller.clear();
                            refreshTodoList();
                            Navigator.of(context).pop();
                          },
                          child: const Text("Add"))
                    ],
                  );
                });
          },
        ),
      ),
    );
  }
}
