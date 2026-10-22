class Todo {
  final String id;
  final String userId;
  final String todo;
  final bool isCompleted;

  const Todo({
    required this.id,
    required this.userId,
    required this.todo,
    required this.isCompleted,
  });

  Todo copyWith({String? id, String? userId, String? todo, bool? isCompleted}) {
    return Todo(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      todo: todo ?? this.todo,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
