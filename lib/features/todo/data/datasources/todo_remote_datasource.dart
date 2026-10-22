import '../dtos/todo_dto.dart';
import '../dtos/update_todo_dto.dart';

abstract class TodoRemoteDatasource {
  Future<List<TodoDto>> fetchTodoList();

  /// Persists a new completion value for the todo identified by [id] and
  /// returns the updated representation as reported by the server.
  Future<TodoDto> updateTodoCompletion({
    required String id,
    required UpdateTodoDto body,
  });
}
