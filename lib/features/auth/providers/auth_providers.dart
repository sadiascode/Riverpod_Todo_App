import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/infrastructure/di/network_providers.dart';
import '../application/usecases/login_usecase.dart';
import '../data/datasources/auth_remote_datasource.dart';
import '../data/datasources/auth_remote_datasource_impl.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../domain/repositories/auth_repository.dart';
import '../presentation/controllers/auth_controller.dart';

final authRemoteDatasourceProvider = Provider<AuthRemoteDatasource>((ref) {
  final http = ref.watch(httpClientProvider);
  return AuthRemoteDatasourceImpl(http);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remote = ref.watch(authRemoteDatasourceProvider);
  return AuthRepositoryImpl(
    remote,
    refreshDatasource: ref.watch(tokenRefreshDatasourceProvider),
    tokenStorage: ref.watch(authTokenStorageProvider),
  );
});

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return LoginUseCase(repo);
});

final authControllerProvider =
    AsyncNotifierProvider<AuthController, AuthControllerState>(
      AuthController.new,
    );

/// Returns the persisted user (if any) on app start so the splash screen can
/// decide whether to navigate to login or straight to home.
final sessionProvider = FutureProvider<bool>((ref) async {
  final repo = ref.watch(authRepositoryProvider);
  final result = await repo.restoreSession();
  return result.isSuccess;
});
