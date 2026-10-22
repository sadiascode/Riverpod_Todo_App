import '../../../../core/common/result.dart';
import '../entities/todo.dart';
import '../failures/todo_failure.dart';

abstract class TodoRepository {
  Future<Result<TodoFailure, List<Todo>>> fetchTodoList();

  /// Persists a new completion value for the todo identified by [id] and
  /// returns the updated entity reported by the server.
  Future<Result<TodoFailure, Todo>> updateTodoCompletion({
    required String id,
    required bool isCompleted,
  });
}
