sealed class AuthFailure {
  const AuthFailure();

  String get message;

  @override
  String toString() => message;
}

class InvalidCredentialsFailure extends AuthFailure {
  const InvalidCredentialsFailure();

  @override
  String get message =>
      'Invalid credentials. Please check your username and password.';
  // 'Invalid credentials. Please check your email and password.';
}

class NetworkFailure extends AuthFailure {
  const NetworkFailure();

  @override
  String get message =>
      'Unable to connect. Please check your network connection and try again.';
}

class UnexpectedFailure extends AuthFailure {
  const UnexpectedFailure();

  @override
  String get message =>
      'Something went wrong while logging in. Please try again later.\nIf the problem persists, please contact support.\nError code: UNEXPECTED_FAILURE';
}

class InvalidInputFailure extends AuthFailure {
  final String details;

  const InvalidInputFailure(this.details);

  @override
  String get message => details;
}

class TokenRefreshFailure extends AuthFailure {
  final String? details;

  const TokenRefreshFailure({this.details});

  @override
  String get message =>
      details ?? 'Your session has expired. Please sign in again.';
}

class StorageFailure extends AuthFailure {
  const StorageFailure();

  @override
  String get message => 'Unable to restore your session. Please sign in again.';
}

class NoActiveSessionFailure extends AuthFailure {
  const NoActiveSessionFailure();

  @override
  String get message => 'No active session.';
}
