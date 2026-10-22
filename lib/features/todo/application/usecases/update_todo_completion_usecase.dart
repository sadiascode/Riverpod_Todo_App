import '../../../../core/common/result.dart';
import '../../domain/entities/todo.dart';
import '../../domain/failures/todo_failure.dart';
import '../../domain/repositories/todo_repository.dart';

class UpdateTodoCompletionUseCase {
  final TodoRepository _repo;

  const UpdateTodoCompletionUseCase(this._repo);

  Future<Result<TodoFailure, Todo>> call({
    required String id,
    required bool isCompleted,
  }) {
    return _repo.updateTodoCompletion(id: id, isCompleted: isCompleted);
  }
}
