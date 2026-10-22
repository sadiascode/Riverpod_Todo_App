import 'package:dio/dio.dart';

import '../../../../core/common/result.dart';
import '../../../../core/utils/logger/logger.dart';
import '../../domain/entities/todo.dart';
import '../../domain/failures/todo_failure.dart';
import '../../domain/repositories/todo_repository.dart';
import '../datasources/todo_remote_datasource.dart';
import '../dtos/update_todo_dto.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoRemoteDatasource _remote;

  const TodoRepositoryImpl(this._remote);

  @override
  Future<Result<TodoFailure, List<Todo>>> fetchTodoList() async {
    try {
      final dtoList = await _remote.fetchTodoList();
      final todos = dtoList.map((dto) => dto.toEntity()).toList();
      return SuccessResult<TodoFailure, List<Todo>>(todos);
    } on DioException catch (e, stack) {
      Logger.error(
        'TodoRepositoryImpl.fetchTodoList failed',
        error: e,
        stackTrace: stack,
      );
      return const FailureResult<TodoFailure, List<Todo>>(NetworkFailure());
    } catch (e, stack) {
      Logger.error(
        'TodoRepositoryImpl.fetchTodoList unexpected failure',
        error: e,
        stackTrace: stack,
      );
      return const FailureResult<TodoFailure, List<Todo>>(UnexpectedFailure());
    }
  }

  @override
  Future<Result<TodoFailure, Todo>> updateTodoCompletion({
    required String id,
    required bool isCompleted,
  }) async {
    try {
      final dto = await _remote.updateTodoCompletion(
        id: id,
        body: UpdateTodoDto(completed: isCompleted),
      );
      return SuccessResult<TodoFailure, Todo>(dto.toEntity());
    } on DioException catch (e, stack) {
      Logger.error(
        'TodoRepositoryImpl.updateTodoCompletion failed '
        '(id=$id, isCompleted=$isCompleted)',
        error: e,
        stackTrace: stack,
      );
      return const FailureResult<TodoFailure, Todo>(NetworkFailure());
    } catch (e, stack) {
      Logger.error(
        'TodoRepositoryImpl.updateTodoCompletion unexpected failure '
        '(id=$id, isCompleted=$isCompleted)',
        error: e,
        stackTrace: stack,
      );
      return const FailureResult<TodoFailure, Todo>(UnexpectedFailure());
    }
  }
}
