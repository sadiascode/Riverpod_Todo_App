import '../failures/auth_failure.dart';

class Username {
  final String value;
  final String? error;

  const Username._(this.value, this.error);

  static const int minLength = 6;
  static const int maxLength = 25;

  factory Username(String input) {
    final trimmed = input.trim();

    if (trimmed.isEmpty) {
      return const Username._('', 'Username is required.');
    }

    if (trimmed.length < minLength) {
      return const Username._(
        '',
        'Username must be at least $minLength characters long.',
      );
    }

    if (trimmed.length > maxLength) {
      return const Username._(
        '',
        'Username must be no more than $maxLength characters long.',
      );
    }

    return Username._(trimmed, null);
  }

  bool get isValid => error == null;

  AuthFailure? get failure =>
      error == null ? null : InvalidInputFailure(error!);
}
