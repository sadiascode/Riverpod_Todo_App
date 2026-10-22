import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/models/todo_update_feedback.dart';

/// One-shot channel for the presentation layer to react to the outcome of
/// `TodoController.updateTodoCompletion`. The controller publishes a fresh
/// [TodoUpdateFeedback] via [publish] after each attempt; the page
/// listens on the matching provider and consumes the value via [clear]
/// once it has shown the snackbar.
///
/// Kept next to `TodoController` under `presentation/controllers/` so all
/// Riverpod notifier behaviour for this feature lives in one place. The
/// `providers/` folder remains pure dependency-injection wiring.
class TodoUpdateFeedbackNotifier extends Notifier<TodoUpdateFeedback?> {
  @override
  TodoUpdateFeedback? build() => null;

  /// Publish a new feedback value. Called by [TodoController] after each
  /// `updateTodoCompletion` attempt.
  void publish(TodoUpdateFeedback feedback) {
    state = feedback;
  }

  /// Clears the channel. The presentation layer calls this once it has
  /// surfaced the snackbar so subsequent rebuilds do not re-trigger it.
  void clear() {
    state = null;
  }
}
