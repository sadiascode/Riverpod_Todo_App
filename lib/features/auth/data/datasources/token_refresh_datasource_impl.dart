import 'package:dio/dio.dart';

import '../../../../core/infrastructure/network/http_client.dart';
import '../../../../core/utils/value_parsing/safe_value_parser.dart';
import 'token_refresh_datasource.dart';

class TokenRefreshDatasourceImpl implements TokenRefreshDatasource {
  final HttpClient _http;

  const TokenRefreshDatasourceImpl(this._http);

  @override
  Future<({String accessToken, String refreshToken})> refresh({
    required String refreshToken,
  }) async {
    try {
      final response = await _http.dio.post<Map<String, dynamic>>(
        'auth/refresh',
        data: {'refreshToken': refreshToken},
      );

      final data = response.data;
      if (data == null) {
        throw const TokenRefreshException('Empty refresh response');
      }

      final newAccess = SafeValueParser.readString(data['accessToken']);
      final newRefresh = SafeValueParser.readString(data['refreshToken']);

      if (newAccess.isEmpty || newRefresh.isEmpty) {
        throw const TokenRefreshException('Missing tokens in refresh response');
      }

      return (accessToken: newAccess, refreshToken: newRefresh);
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      // Any 4xx on refresh means the refresh token itself is invalid/revoked.
      if (status != null && status >= 400 && status < 500) {
        throw const TokenRefreshException('Refresh token rejected');
      }
      // Anything else is a transient transport problem — rethrow as-is and
      // let the interceptor decide what to do.
      rethrow;
    }
  }
}
