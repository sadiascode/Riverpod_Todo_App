import '../../domain/failures/todo_failure.dart';

/// A one-shot feedback value published by [TodoController] after each
/// `updateTodoCompletion` attempt. The presentation layer subscribes to
/// the matching provider and renders a snackbar; consumers should treat
/// the value as ephemeral (it is cleared once consumed).
sealed class TodoUpdateFeedback {
  const TodoUpdateFeedback();
}

class TodoUpdateSuccess extends TodoUpdateFeedback {
  const TodoUpdateSuccess();
}

class TodoUpdateFailure extends TodoUpdateFeedback {
  final TodoFailure failure;
  const TodoUpdateFailure(this.failure);
}
