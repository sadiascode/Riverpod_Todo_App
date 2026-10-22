import 'package:dio/dio.dart';

import '../../../../core/infrastructure/network/http_client.dart';
import '../../../../core/utils/logger/logger.dart';
import '../datasources/todo_remote_datasource.dart';
import '../dtos/todo_dto.dart';
import '../dtos/update_todo_dto.dart';

class TodoRemoteDatasourceImpl implements TodoRemoteDatasource {
  final HttpClient _http;

  const TodoRemoteDatasourceImpl(this._http);

  @override
  Future<List<TodoDto>> fetchTodoList() async {
    try {
      final response = await _http.dio.get<Map<String, dynamic>>('todos');
      final data = response.data;

      if (data == null) {
        Logger.log('fetchTodoList error: No data received');
        return const [];
      }

      final rawList = data['todos'] as List<dynamic>?;
      if (rawList == null) {
        Logger.log('fetchTodoList error: No todos list in response');
        return const [];
      }

      return rawList
          .cast<Map<String, dynamic>>()
          .map((item) => TodoDto.fromJson(item))
          .toList();
    } on DioException catch (e) {
      Logger.log('fetchTodoList DioException: ${e.toString()}');
      _rethrowAsNetwork(e);
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<TodoDto> updateTodoCompletion({
    required String id,
    required UpdateTodoDto body,
  }) async {
    try {
      final response = await _http.dio.put<Map<String, dynamic>>(
        'todos/$id',
        data: body.toJson(),
      );
      final data = response.data;

      Logger.log('updateTodoCompletion response: $data');

      if (data == null) {
        Logger.log('updateTodoCompletion error: No data received');
        throw DioException(
          requestOptions: response.requestOptions,
          type: DioExceptionType.unknown,
        );
      }

      return TodoDto.fromJson(data);
    } on DioException catch (e) {
      Logger.log('updateTodoCompletion DioException: ${e.toString()}');
      _rethrowAsNetwork(e);
    } catch (_) {
      rethrow;
    }
  }

  /// Normalises transport-level Dio errors into a single network-style
  /// [DioException] so the repository can map them to [NetworkFailure]
  /// without duplicating the classification logic per endpoint.
  Never _rethrowAsNetwork(DioException e) {
    final isNetwork =
        e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.unknown;

    if (isNetwork) {
      throw DioException(
        requestOptions: e.requestOptions,
        type: DioExceptionType.unknown,
      );
    }

    // Re-throw the original exception to preserve the failure shape for
    // the repository to classify (e.g. server errors stay non-network).
    throw e;
  }
}
