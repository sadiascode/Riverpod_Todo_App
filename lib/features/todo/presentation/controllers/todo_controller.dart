import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/models/todo_update_feedback.dart';
import '../../application/usecases/fetch_todo_list_usecase.dart';
import '../../application/usecases/update_todo_completion_usecase.dart';
import '../../domain/entities/todo.dart';
import '../../domain/failures/todo_failure.dart';
import '../../providers/todo_providers.dart';

class TodoControllerState {
  final List<Todo> todos;
  final TodoFailure? failure;

  const TodoControllerState({required this.todos, this.failure});

  const TodoControllerState.initial() : this(todos: const []);

  TodoControllerState copyWith({List<Todo>? todos, TodoFailure? failure}) {
    return TodoControllerState(todos: todos ?? this.todos, failure: failure);
  }
}

class TodoController extends AsyncNotifier<TodoControllerState> {
  late FetchTodoListUseCase _fetchTodoListUseCase;
  late UpdateTodoCompletionUseCase _updateTodoCompletionUseCase;

  @override
  Future<TodoControllerState> build() async {
    _fetchTodoListUseCase = ref.read(fetchTodoListUseCaseProvider);
    _updateTodoCompletionUseCase = ref.read(
      updateTodoCompletionUseCaseProvider,
    );
    return await _loadTodos();
  }

  Future<TodoControllerState> _loadTodos() async {
    state = const AsyncLoading();

    final result = await _fetchTodoListUseCase();

    return result.fold(
      (failure) => TodoControllerState.initial().copyWith(failure: failure),
      (todos) => TodoControllerState.initial().copyWith(todos: todos),
    );
  }

  Future<void> refresh() async {
    state = AsyncValue.data(await _loadTodos());
  }

  /// Updates the completion flag for [todo] to [isCompleted].
  ///
  /// The local state is mutated immediately (optimistic update) so the
  /// checkbox reflects the new value without waiting for the network. On
  /// failure the previous list is restored; on success the entry is
  /// replaced with whatever the server returned.
  ///
  /// As a side-effect, publishes a one-shot [TodoUpdateFeedback] on
  /// [todoUpdateFeedbackProvider] so the presentation layer can surface a
  /// snackbar. The repository is responsible for logging the raw transport
  /// error; this controller only forwards the user-friendly failure.
  Future<void> updateTodoCompletion(Todo todo, bool isCompleted) async {
    final current = state.value;
    if (current == null) return;

    final previousTodos = current.todos;
    final optimisticTodos = [
      for (final t in previousTodos)
        if (t.id == todo.id) t.copyWith(isCompleted: isCompleted) else t,
    ];

    state = AsyncValue.data(current.copyWith(todos: optimisticTodos));

    final result = await _updateTodoCompletionUseCase(
      id: todo.id,
      isCompleted: isCompleted,
    );

    result.fold(
      (failure) {
        // Roll back to the snapshot taken before the optimistic update
        // so the UI matches the source of truth (the server).
        state = AsyncValue.data(current.copyWith(todos: previousTodos));
        ref
            .read(todoUpdateFeedbackProvider.notifier)
            .publish(TodoUpdateFailure(failure));
      },
      (updatedTodo) {
        // Sync the local entry with the server's representation in case
        // it normalised any field.
        final syncedTodos = [
          for (final t in state.value!.todos)
            if (t.id == updatedTodo.id) updatedTodo else t,
        ];
        state = AsyncValue.data(state.value!.copyWith(todos: syncedTodos));
        ref
            .read(todoUpdateFeedbackProvider.notifier)
            .publish(const TodoUpdateSuccess());
      },
    );
  }
}
