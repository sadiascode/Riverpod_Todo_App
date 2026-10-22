/// Thrown by refresh-token datasources when the server rejects the refresh
/// token (revoked, expired, or otherwise invalid). The auth interceptor
/// translates this into a 401 propagation that forces the user back to the
/// login screen.
class TokenRefreshException implements Exception {
  final String message;
  const TokenRefreshException(this.message);

  @override
  String toString() => 'TokenRefreshException: $message';
}
