class SafeValueParser {
  const SafeValueParser._();

  static int readInt(Object? value, {int defaultValue = 0}) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value) ?? defaultValue;
    }
    return defaultValue;
  }

  static String readString(Object? value, {String defaultValue = ''}) {
    if (value == null) {
      return defaultValue;
    }
    return value.toString();
  }

  static bool readBool(Object? value, {bool defaultValue = false}) {
    if (value is bool) {
      return value;
    }
    if (value is num) {
      return value != 0;
    }
    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }
    return defaultValue;
  }
}
