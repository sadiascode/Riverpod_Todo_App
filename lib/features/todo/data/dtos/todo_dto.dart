import '../../../../core/utils/value_parsing/safe_value_parser.dart';
import '../../domain/entities/todo.dart';

class TodoDto {
  final int id;
  final int userId;
  final String todo;
  final bool completed;

  const TodoDto({
    required this.id,
    required this.userId,
    required this.todo,
    required this.completed,
  });

  factory TodoDto.fromJson(Map<String, dynamic> json) {
    return TodoDto(
      id: SafeValueParser.readInt(json['id']),
      userId: SafeValueParser.readInt(json['userId']),
      todo: SafeValueParser.readString(json['todo']),
      completed: SafeValueParser.readBool(json['completed']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'todo': todo,
    'completed': completed,
  };

  Todo toEntity() => Todo(
    id: id.toString(),
    todo: todo,
    userId: userId.toString(),
    isCompleted: completed,
  );
}
