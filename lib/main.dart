import 'package:flutter/material.dart';
import 'package:flutter_todo_app/view/myapp.dart';

import 'data/database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final DatabaseHelper databaseHelper = DatabaseHelper();
  await databaseHelper.initializeDatabase();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "TODO APP",
    home: MyApp(
      databaseHelper: databaseHelper,
    ),
  ));
}
