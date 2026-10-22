import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../core/infrastructure/network/http_client.dart';
import '../../../../core/utils/logger/logger.dart';
import '../datasources/auth_remote_datasource.dart';
import '../dtos/user_dto.dart';
import '../../domain/failures/auth_failure.dart';

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final HttpClient _http;

  const AuthRemoteDatasourceImpl(this._http);

  @override
  Future<UserDto> login({
    required String username,
    // required String email,
    required String password,
  }) async {
    try {
      final String jsonString = jsonEncode({
        'username': username,
        'password': password,
      });

      final response = await _http.dio.post<Map<String, dynamic>>(
        'auth/login',
        data: jsonString,
        // data: {'username': username, 'password': password},
      );

      final data = response.data;

      if (data == null) {
        Logger.log('login error: No data received');
        throw const UnexpectedFailure();
      }

      return UserDto.fromJson(data);
    } on DioException catch (e) {
      final isNetwork =
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.unknown;

      if (isNetwork) {
        Logger.log('login error: Network issue: ${e.message}');
        throw const NetworkFailure();
      }

      final status = e.response?.statusCode;

      if (status == 400 || status == 401 || status == 403) {
        Logger.log('login error: Invalid credentials: ${e.message}');
        throw const InvalidCredentialsFailure();
      }

      Logger.log('login error: Unknown error: ${e.message}');
      throw const UnexpectedFailure();
    } catch (e) {
      Logger.log('login error: Unexpected error: ${e.toString()}');
      throw const UnexpectedFailure();
    }
  }
}
