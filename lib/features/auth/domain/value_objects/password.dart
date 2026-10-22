import '../failures/auth_failure.dart';

class Password {
  final String value;
  final String? error;

  const Password._(this.value, this.error);

  static const int minLength = 6;
  static const int maxLength = 128;

  // Must contain at least one: uppercase, lowercase, digit, special character.
  static final RegExp _uppercase = RegExp(r'[A-Z]');
  static final RegExp _lowercase = RegExp(r'[a-z]');
  static final RegExp _digit = RegExp(r'[0-9]');
  // Anything that is not a letter, digit, or whitespace.
  static final RegExp _special = RegExp(
    r"[!@#$%^&*()_+\-={}\[\]:;'"
    r'"'
    r"<>?,./~`|\\]",
  );

  factory Password(String input) {
    final raw = input;

    if (raw.isEmpty) {
      return const Password._('', 'Password is required.');
    }

    if (raw.length < minLength) {
      return Password._(
        '',
        'Password must be at least $minLength characters long.',
      );
    }

    if (raw.length > maxLength) {
      return Password._(
        '',
        'Password is too long (max $maxLength characters).',
      );
    }

    if (raw.contains(RegExp(r'\s'))) {
      return const Password._('', 'Password must not contain spaces.');
    }

    // if (!_uppercase.hasMatch(raw)) {
    //   return const Password._(
    //     '',
    //     'Password must contain at least one uppercase letter.',
    //   );
    // }

    // if (!_lowercase.hasMatch(raw)) {
    //   return const Password._(
    //     '',
    //     'Password must contain at least one lowercase letter.',
    //   );
    // }

    // if (!_digit.hasMatch(raw)) {
    //   return const Password._('', 'Password must contain at least one digit.');
    // }

    // if (!_special.hasMatch(raw)) {
    //   return const Password._(
    //     '',
    //     'Password must contain at least one special character.',
    //   );
    // }

    return Password._(raw, null);
  }

  bool get isValid => error == null;

  AuthFailure? get failure =>
      error == null ? null : InvalidInputFailure(error!);
}
