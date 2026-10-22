import '../../../../core/common/result.dart';
import '../entities/user.dart';
import '../failures/auth_failure.dart';
import '../value_objects/email.dart';
import '../value_objects/password.dart';
import '../value_objects/username.dart';

abstract class AuthRepository {
  Future<Result<AuthFailure, User>> login({
    required Username username,
    // required Email email,
    required Password password,
  });

  /// Returns the persisted user if both tokens are still stored, otherwise
  /// a [StorageFailure] (treated as "logged out") so the UI can route to
  /// the auth screen.
  Future<Result<AuthFailure, User>> restoreSession();

  /// Clears any persisted tokens / cached user. Always succeeds.
  Future<void> logout();

  /// Forces a refresh of the access token using the stored refresh token.
  Future<Result<AuthFailure, void>> refreshTokens();
}
