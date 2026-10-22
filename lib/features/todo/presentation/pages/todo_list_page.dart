import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/routes.dart';
import '../../../../core/utils/logger/logger.dart';
import '../../application/models/todo_update_feedback.dart';
import '../../providers/todo_providers.dart';
import '../../../auth/providers/auth_providers.dart';

class TodoListPage extends ConsumerWidget {
  const TodoListPage({super.key});

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    // Clear persisted tokens + the in-memory controller state, then route
    // the user back to the login screen.
    await ref.read(authControllerProvider.notifier).logout();
    if (!context.mounted) return;
    context.pushReplacementNamed(Routes.login);
  }

  /// Translates a [TodoUpdateFeedback] emitted by the controller into a
  /// user-friendly snackbar. The raw transport / domain details are
  /// already logged in the repository; the snackbar intentionally only
  /// surfaces the polished failure message.
  void _showUpdateFeedback(
    BuildContext context,
    WidgetRef ref,
    TodoUpdateFeedback feedback,
  ) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();

    final (text, background) = switch (feedback) {
      TodoUpdateSuccess() => (
        'Task updated successfully.',
        Colors.green.shade700,
      ),
      TodoUpdateFailure(failure: final f) => (f.message, Colors.red.shade700),
    };

    messenger.showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: background,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );

    // Consume the one-shot value so subsequent rebuilds (e.g. state
    // updates) do not re-trigger the snackbar.
    ref.read(todoUpdateFeedbackProvider.notifier).clear();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todosAsync = ref.watch(todoControllerProvider);

    // React to update outcomes published by the controller. We use
    // `ref.listen` (instead of `watch`) because this side-effect must not
    // rebuild the whole page — only fire once per non-null value.
    ref.listen<TodoUpdateFeedback?>(todoUpdateFeedbackProvider, (
      previous,
      next,
    ) {
      if (next != null) {
        Logger.log(
          'TodoListPage received update feedback: ${next.runtimeType}',
        );
        _showUpdateFeedback(context, ref, next);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: () =>
                ref.read(todoControllerProvider.notifier).refresh(),
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            tooltip: 'Logout',
            onPressed: () => _logout(context, ref),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: todosAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Error: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () =>
                    ref.read(todoControllerProvider.notifier).refresh(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (state) {
          if (state.failure != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(state.failure.toString(), textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () =>
                          ref.read(todoControllerProvider.notifier).refresh(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: state.todos.length,
            itemBuilder: (_, index) {
              final todo = state.todos[index];
              return ListTile(
                title: Text(todo.userId),
                subtitle: Text(todo.todo),
                leading: Checkbox(
                  value: todo.isCompleted,
                  onChanged: (value) {
                    ref
                        .read(todoControllerProvider.notifier)
                        .updateTodoCompletion(todo, value ?? false);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
