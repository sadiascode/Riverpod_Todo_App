import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/infrastructure/di/network_providers.dart';
import '../application/models/todo_update_feedback.dart';
import '../application/usecases/fetch_todo_list_usecase.dart';
import '../application/usecases/update_todo_completion_usecase.dart';
import '../data/datasources/todo_remote_datasource.dart';
import '../data/datasources/todo_remote_datasource_impl.dart';
import '../data/repositories/todo_repository_impl.dart';
import '../domain/repositories/todo_repository.dart';
import '../presentation/controllers/todo_controller.dart';
import '../presentation/controllers/todo_update_feedback_notifier.dart';

final todoRemoteDatasourceProvider = Provider<TodoRemoteDatasource>((ref) {
  final http = ref.watch(httpClientProvider);
  return TodoRemoteDatasourceImpl(http);
});

final todoRepositoryProvider = Provider<TodoRepository>((ref) {
  final remote = ref.watch(todoRemoteDatasourceProvider);
  return TodoRepositoryImpl(remote);
});

final fetchTodoListUseCaseProvider = Provider<FetchTodoListUseCase>((ref) {
  final repo = ref.watch(todoRepositoryProvider);
  return FetchTodoListUseCase(repo);
});

final updateTodoCompletionUseCaseProvider =
    Provider<UpdateTodoCompletionUseCase>((ref) {
      final repo = ref.watch(todoRepositoryProvider);
      return UpdateTodoCompletionUseCase(repo);
    });

final todoControllerProvider =
    AsyncNotifierProvider<TodoController, TodoControllerState>(
      TodoController.new,
    );

final todoUpdateFeedbackProvider =
    NotifierProvider<TodoUpdateFeedbackNotifier, TodoUpdateFeedback?>(
      TodoUpdateFeedbackNotifier.new,
    );
