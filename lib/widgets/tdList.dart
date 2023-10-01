import 'package:flutter/material.dart';
import 'package:flutter_todo_app/data/database_helper.dart';

import '../model/model.dart';

class TodoList extends StatefulWidget {
  final DatabaseHelper databaseHelper;
  final VoidCallback refreshCallBack;
  const TodoList(
      {super.key, required this.refreshCallBack, required this.databaseHelper});

  @override
  State<TodoList> createState() => TodoListState();
}

class TodoListState extends State<TodoList> {
  late Future<List<Todo>> todos;
  Widget checkIcon = const Icon(Icons.check_box_outline_blank_rounded);
  bool check = false;
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    refreshTodoList();
  }

  Future<void> refreshTodoList() async {
    setState(() {
      todos = widget.databaseHelper.getTodos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Todo>>(
        future: todos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Center(
              child: AlertDialog(
                title: Text("Error: ${snapshot.error}"),
              ),
            );
          }
          if (snapshot.hasData) {
            final todoList = snapshot.data!;
            return ListView.builder(
                itemCount: todoList.length,
                itemBuilder: (context, index) {
                  final todo = todoList[index];
                  return Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(20),
                          //shape:
                        ),
                        child: ListTile(
                          title: Text(
                            todo.title!,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          trailing: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  if (check == false) {
                                    setState(() {
                                      checkIcon = const Icon(
                                        Icons.check_box,
                                        color: Colors.green,
                                      );
                                      check = true;
                                    });
                                  } else if (check == true) {
                                    setState(() {
                                      checkIcon = const Icon(Icons
                                          .check_box_outline_blank_rounded);
                                      check = false;
                                    });
                                  }
                                },
                                icon: checkIcon,
                              ),
                              IconButton(
                                onPressed: () async {
                                  await widget.databaseHelper
                                      .deleteTodo(todo.id!);
                                  widget.refreshCallBack();
                                },
                                icon: const Icon(
                                  Icons.delete_rounded,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                });
          }
          return const Center(
            child: Text("There is no TOdo"),
          );
        });
  }
}
