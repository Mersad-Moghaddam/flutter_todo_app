class Todo {
  int? id;
  String? title;
  int? isCompleted;

  Todo({this.id, required this.title, required this.isCompleted});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted!,
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
        id: map['id'], title: map['title'], isCompleted: map['isCompleted']);
  }
}
