import '../failures/auth_failure.dart';

class Email {
  final String value;
  final String? error;

  const Email._(this.value, this.error);

  // RFC-5322 friendly, pragmatic pattern: local@domain.tld
  static final RegExp _emailPattern = RegExp(
    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+"
    r'@'
    r'[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?'
    r'(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)+$',
  );

  // RFC 5321 practical limits.
  static const int _maxLocalLength = 64;
  static const int _maxTotalLength = 254;

  factory Email(String input) {
    final trimmed = input.trim();

    if (trimmed.isEmpty) {
      return const Email._('', 'Email is required.');
    }

    if (trimmed.length > _maxTotalLength) {
      return Email._(
        '',
        'Email is too long (max $_maxTotalLength characters).',
      );
    }

    final atIndex = trimmed.indexOf('@');
    if (atIndex <= 0 || atIndex == trimmed.length - 1) {
      return const Email._('', 'Enter a valid email address.');
    }

    final local = trimmed.substring(0, atIndex);
    if (local.length > _maxLocalLength) {
      return const Email._('', 'The local part of the email is too long.');
    }

    // Reject leading/trailing or consecutive dots in the local-part.
    if (local.startsWith('.') || local.endsWith('.') || local.contains('..')) {
      return const Email._('', 'Enter a valid email address.');
    }

    if (!_emailPattern.hasMatch(trimmed)) {
      return const Email._('', 'Enter a valid email address.');
    }

    return Email._(trimmed, null);
  }

  bool get isValid => error == null;

  AuthFailure? get failure =>
      error == null ? null : InvalidInputFailure(error!);
}
