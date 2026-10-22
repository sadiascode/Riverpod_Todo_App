import '../dtos/user_dto.dart';

abstract class AuthRemoteDatasource {
  Future<UserDto> login({required String username, required String password});
  // Future<UserDto> login({required String email, required String password});
}
