import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/model.dart';

class DatabaseHelper {
  late Database _database;
  // Create DataBase
  Future<void> initializeDatabase() async {
    try {
      final String path = join(await getDatabasesPath(), "myTodoApp.db");
      await deleteDatabase(path);
      _database = await openDatabase(path, version: 2,
          onCreate: (Database db, int version) {
        db.execute('''
        CREATE TABLE todos(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        isCompleted INTEGER
        ) 
        ''');
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      }
      rethrow;
    }
  }

// Add to DataBase
  Future<int> insertTodo(Todo todo) async {
    return await _database.insert('todos', todo.toMap());
  }

// Get from Database
  Future<List<Todo>> getTodos() async {
    final List<Map<String, dynamic>> maps = await _database.query('todos');
    return List.generate(maps.length, (index) => Todo.fromMap(maps[index]));
  }

// Update DataBase
  Future<int> updateTodo(Todo todo) async {
    return await _database
        .update("todos", todo.toMap(), where: 'id = ?', whereArgs: [todo.id]);
  }

// Delete From DataBase
  Future<int> deleteTodo(int id) async {
    return await _database.delete("todos", where: 'id = ?', whereArgs: [id]);
  }
}
