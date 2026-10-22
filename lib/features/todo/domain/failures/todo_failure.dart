sealed class TodoFailure {
  const TodoFailure();

  String get message;

  @override
  String toString() => message;
}

class NetworkFailure extends TodoFailure {
  const NetworkFailure();

  @override
  String get message =>
      'Unable to fetch tasks. Please check your network connection.';
}

class UnexpectedFailure extends TodoFailure {
  const UnexpectedFailure();

  @override
  String get message =>
      'Something went wrong while loading tasks. Please try again later.';
}
