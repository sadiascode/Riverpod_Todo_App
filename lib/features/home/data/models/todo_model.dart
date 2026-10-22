class Task {
  final int id;
  final String title;
  final bool completed;

  Task({required this.id, required this.title, required this.completed});

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    id: json['id'] as int,
    title: json['title'] as String,
    completed: json['completed'] as bool,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'completed': completed,
  };
}

class CreateTaskRequest {
  final String title;
  final bool completed;
  CreateTaskRequest({required this.title, required this.completed});

  Map<String, dynamic> toJson() => {'title': title, 'completed': completed};
}

class UpdateTaskRequest {
  final String title;
  final bool completed;
  UpdateTaskRequest({required this.title, required this.completed});

  Map<String, dynamic> toJson() => {'title': title, 'completed': completed};
}
