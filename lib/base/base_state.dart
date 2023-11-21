enum DataStatus {
  initial,
  loading,
  error,
  success;
}

class BaseState<T> {
  const BaseState({
    this.status = DataStatus.initial,
    this.message,
    this.data,
  });

  final DataStatus status;
  final String? message;
  final T? data;

  BaseState<T> copyWith({
    DataStatus? status,
    String? message,
    T? data,
  }) =>
      BaseState<T>(
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data,
      );
}
