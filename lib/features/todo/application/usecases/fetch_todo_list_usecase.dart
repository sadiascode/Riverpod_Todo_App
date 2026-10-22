import '../../../../core/common/result.dart';
import '../../domain/entities/todo.dart';
import '../../domain/failures/todo_failure.dart';
import '../../domain/repositories/todo_repository.dart';

class FetchTodoListUseCase {
  final TodoRepository _repo;

  const FetchTodoListUseCase(this._repo);

  Future<Result<TodoFailure, List<Todo>>> call() {
    return _repo.fetchTodoList();
  }
}
