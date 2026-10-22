import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../splash/presentation/splash_page.dart';
import '../../providers/auth_providers.dart';
import '../../../todo/presentation/pages/todo_list_page.dart';
import 'login_page.dart';

/// Decides which page to show at app start:
/// - splash while the persisted session is being read,
/// - [LoginPage] when there is no active session,
/// - [TodoListPage] otherwise.
///
/// After a successful login, the [LoginPage] itself pushes a replacement
/// onto the navigator so this widget is not reactive to login state changes
/// (which keeps things simple and avoids double-routing).
class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionAsync = ref.watch(sessionProvider);

    return sessionAsync.when(
      loading: () => const SplashPage(),
      error: (_, _) => const LoginPage(),
      data: (isAuthenticated) {
        if (isAuthenticated) {
          return const TodoListPage();
        }
        return const LoginPage();
      },
    );
  }
}
