import 'package:dio/dio.dart';

import '../../utils/logger/logger.dart';

/// Centralized HTTP client that owns the [Dio] instance and its app-wide
/// configuration (base URL, timeouts, content-type). Concrete network
/// concerns — base options, request/response transforms, common headers —
/// should be configured here so datasources stay transport-agnostic.
///
/// The [Dio] is exposed so lower-level consumers (such as the auth
/// interceptor when retrying a failed request) can reuse the same
/// connection pool / interceptors.
class HttpClient {
  HttpClient({
    String baseUrl = 'https://dummyjson.com/',
    Duration connectTimeout = const Duration(seconds: 10),
    Duration receiveTimeout = const Duration(seconds: 10),
    Duration sendTimeout = const Duration(seconds: 10),
    Map<String, String>? defaultHeaders,
  }) : dio = Dio(
         BaseOptions(
           baseUrl: baseUrl,
           connectTimeout: connectTimeout,
           receiveTimeout: receiveTimeout,
           sendTimeout: sendTimeout,
           headers: {
             'Accept': 'application/json',
             'Content-Type': 'application/json',
             ...?defaultHeaders,
           },
           responseType: ResponseType.json,
         ),
       ) {
    dio.interceptors.add(
      // LogInterceptor(
      //   request: true,
      //   requestHeader: true,
      //   requestBody: true,
      //   responseHeader: true,
      //   responseBody: true,
      //   error: true,
      //   logPrint: (object) {
      //     // Use the Logger class to log the message);
      //     Logger.log(object.toString());
      //   },
      // ),
      InterceptorsWrapper(
        onRequest: (options, handler) {
          Logger.log('REQUEST: [${options.method}] ${options.uri}');
          Logger.log('BODY: ${options.data}');
          handler.next(options);
        },
        onResponse: (response, handler) {
          Logger.log('RESPONSE: [${response.statusCode}] ${response.realUri}');
          Logger.log('BODY: ${response.data}');
          handler.next(response);
        },
        onError: (e, handler) {
          final uri = e.requestOptions.uri;
          Logger.log('ERROR: [${e.response?.statusCode ?? "?"}] $uri');
          Logger.log('MESSAGE: ${e.message}');
          // Optionally log server error body if present:
          // Logger.log('BODY: ${e.response?.data}');
          handler.next(e);
        },
      ),
    );
  }

  /// The configured [Dio] used for all HTTP traffic. Add interceptors
  /// (auth, logging, retry, etc.) to this instance.
  final Dio dio;
}
