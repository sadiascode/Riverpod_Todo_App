import '../../../../core/common/result.dart';
import '../../domain/entities/user.dart';
import '../../domain/failures/auth_failure.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/value_objects/email.dart';
import '../../domain/value_objects/password.dart';
import '../../domain/value_objects/username.dart';

class LoginUseCase {
  final AuthRepository _repo;
  const LoginUseCase(this._repo);

  Future<Result<AuthFailure, User>> call({
    required Username username,
    // required Email email,
    required Password password,
  }) {
    return _repo.login(username: username, password: password);
    // return _repo.login(email: email, password: password);
  }
}
