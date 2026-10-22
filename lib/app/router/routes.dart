import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/auth_gate.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/splash/presentation/splash_page.dart';
import '../../features/todo/presentation/pages/todo_list_page.dart';

extension Convert on String {
  String get p => '/$this';
}

class Routes {
  Routes._();

  static const auth = 'auth';
  static const splash = 'splash';
  static const onboarding = 'onboarding';
  static const login = 'login';
  static const home = 'home';
  static const todo = 'todo';
  static const profile = 'profile';
  static const bookmarks = 'bookmarks';
  static const settings = 'settings';
  static const search = 'search';
}

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: Routes.auth.p,
    routes: [
      GoRoute(path: '/', redirect: (context, state) => Routes.auth.p),
      GoRoute(
        path: Routes.auth.p,
        name: Routes.auth,
        builder: (context, state) => const AuthGate(),
      ),
      GoRoute(
        path: Routes.splash.p,
        name: Routes.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: Routes.login.p,
        name: Routes.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: Routes.todo.p,
        name: Routes.todo,
        builder: (context, state) => const TodoListPage(),
      ),
    ],
  );
});
