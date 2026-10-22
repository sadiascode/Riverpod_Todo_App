import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/auth_token_storage.dart';
import '../../../features/auth/data/datasources/token_refresh_datasource.dart';
import '../../../features/auth/data/datasources/token_refresh_datasource_impl.dart';
import '../network/auth_interceptor.dart';
import '../network/http_client.dart';

/// Shared configuration for every Dio instance. Keeping these in one place
/// lets us swap base URL / timeouts per environment (dev, staging, prod)
/// without touching the providers themselves.
class _ApiConfig {
  static const baseUrl = 'https://dummyjson.com/';
  static const connectTimeout = Duration(seconds: 10);
  static const receiveTimeout = Duration(seconds: 10);
  static const sendTimeout = Duration(seconds: 10);
}

final authTokenStorageProvider = Provider<AuthTokenStorage>((ref) {
  return AuthTokenStorage();
});

/// A minimal, *bare* [HttpClient] used exclusively for refreshing tokens.
/// It deliberately does NOT depend on [httpClientProvider] (no interceptor,
/// no auth header), which breaks the cycle
/// dioProvider ↔ httpClientProvider ↔ tokenRefreshDatasource.
final _refreshHttpClientProvider = Provider<HttpClient>((ref) {
  return HttpClient(
    baseUrl: _ApiConfig.baseUrl,
    connectTimeout: _ApiConfig.connectTimeout,
    receiveTimeout: _ApiConfig.receiveTimeout,
    sendTimeout: _ApiConfig.sendTimeout,
  );
});

final tokenRefreshDatasourceProvider = Provider<TokenRefreshDatasource>((ref) {
  return TokenRefreshDatasourceImpl(ref.watch(_refreshHttpClientProvider));
});

final httpClientProvider = Provider<HttpClient>((ref) {
  final client = HttpClient(
    baseUrl: _ApiConfig.baseUrl,
    connectTimeout: _ApiConfig.connectTimeout,
    receiveTimeout: _ApiConfig.receiveTimeout,
    sendTimeout: _ApiConfig.sendTimeout,
  );

  final interceptor = AuthInterceptor(
    tokenStorage: ref.watch(authTokenStorageProvider),
    refreshDatasource: ref.watch(tokenRefreshDatasourceProvider),
    dio: client.dio,
  );
  client.dio.interceptors.add(interceptor);
  return client;
});

/// Convenience accessor for the configured [Dio] (used by call sites that
/// already speak Dio directly).
final dioProvider = Provider<Dio>((ref) => ref.watch(httpClientProvider).dio);
