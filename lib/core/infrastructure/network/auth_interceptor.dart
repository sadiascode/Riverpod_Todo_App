import 'dart:async';

import 'package:dio/dio.dart';

import '../../services/auth_token_storage.dart';
import '../../../features/auth/data/datasources/token_refresh_datasource.dart';

/// Dio interceptor that:
/// 1. Adds `Authorization: Bearer <accessToken>` to every outgoing request
///    when a token is available.
/// 2. On a 401 response, calls [TokenRefreshDatasource.refresh] exactly once
///    per request. If a fresh token is obtained it is persisted via
///    [AuthTokenStorage] and the original request is retried; otherwise the
///    401 propagates to the caller.
///
/// Concurrent 401s share a single in-flight refresh to avoid token thrashing.
class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor({
    required this.tokenStorage,
    required this.refreshDatasource,
    required this.dio,
  });

  final AuthTokenStorage tokenStorage;
  final TokenRefreshDatasource refreshDatasource;
  // The underlying Dio used to re-issue the failing request after refresh.
  final Dio dio;

  // Mutex around the refresh network call so multiple 401s share one refresh.
  Completer<({String accessToken, String refreshToken})>? _refreshInFlight;

  // Marker added to retried request options so we don't loop forever.
  static const _retriedKey = '__authRetried__';

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip auth header for the refresh endpoint itself.
    if (options.path.contains('/auth/refresh')) {
      return handler.next(options);
    }

    final token = await tokenStorage.readAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final response = err.response;
    final requestOptions = err.requestOptions;
    final alreadyRetried = requestOptions.extra[_retriedKey] == true;
    final isUnauthorized = response?.statusCode == 401;
    final isRefreshEndpoint =
        requestOptions.path.contains('/auth/refresh');

    if (!isUnauthorized || alreadyRetried || isRefreshEndpoint) {
      return handler.next(err);
    }

    final refreshToken =
        await tokenStorage.readRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      return handler.next(err);
    }

    try {
      final newTokens = await _runRefresh(refreshToken);
      await tokenStorage.write(
        accessToken: newTokens.accessToken,
        refreshToken: newTokens.refreshToken,
      );

      // Rebuild the failing request with the new bearer.
      final retried = requestOptions.copyWith(
        extra: {
          ...requestOptions.extra,
          _retriedKey: true,
        },
      );
      retried.headers['Authorization'] = 'Bearer ${newTokens.accessToken}';

      final retryResponse = await dio.fetch<dynamic>(retried);
      return handler.resolve(retryResponse);
    } on TokenRefreshException {
      // Refresh token itself is no longer valid. Clear and let the 401
      // surface so the auth controller can transition to logged out.
      await tokenStorage.clear();
      return handler.next(err);
    } catch (_) {
      // Network failure during refresh — propagate the original error.
      return handler.next(err);
    }
  }

  Future<({String accessToken, String refreshToken})> _runRefresh(
    String refreshToken,
  ) {
    final inFlight = _refreshInFlight;
    if (inFlight != null) {
      return inFlight.future;
    }
    final completer = Completer<({String accessToken, String refreshToken})>();
    _refreshInFlight = completer;
    () async {
      try {
        final result = await refreshDatasource.refresh(
          refreshToken: refreshToken,
        );
        completer.complete(result);
      } catch (error, stack) {
        completer.completeError(error, stack);
      } finally {
        _refreshInFlight = null;
      }
    }();
    return completer.future;
  }
}
