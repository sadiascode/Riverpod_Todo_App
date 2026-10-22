sealed class Result<F, S> {
  const Result();

  T fold<T>(T Function(F failure) onFailure, T Function(S success) onSuccess);

  bool get isFailure => this is FailureResult<F, S>;
  bool get isSuccess => this is SuccessResult<F, S>;
}

final class FailureResult<F, S> extends Result<F, S> {
  final F failure;
  const FailureResult(this.failure);

  @override
  T fold<T>(T Function(F failure) onFailure, T Function(S success) onSuccess) =>
      onFailure(failure);
}

final class SuccessResult<F, S> extends Result<F, S> {
  final S success;
  const SuccessResult(this.success);

  @override
  T fold<T>(T Function(F failure) onFailure, T Function(S success) onSuccess) =>
      onSuccess(success);
}

extension ResultX<F, S> on Result<F, S> {
  Result<F, T> map<T>(T Function(S s) transform) {
    return fold(
      (f) => FailureResult<F, T>(f),
      (s) => SuccessResult<F, T>(transform(s)),
    );
  }
}
