abstract class TaskRepositoryError {
  final String? error;
  final Object? stackTrace;

  TaskRepositoryError({this.error, this.stackTrace});
}

class GenericError extends TaskRepositoryError {
  GenericError({super.error, super.stackTrace});
}

class NotFoundError extends TaskRepositoryError {
  NotFoundError({super.error, super.stackTrace});
}

class PermissionDeniedError extends TaskRepositoryError {
  PermissionDeniedError({super.error, super.stackTrace});
}

class InvalidDataError extends TaskRepositoryError {
  InvalidDataError({super.error, super.stackTrace});
}

class TimeoutError extends TaskRepositoryError {
  TimeoutError({super.error, super.stackTrace});
}

class NetworkError extends TaskRepositoryError {
  NetworkError({super.error, super.stackTrace});
}

class ConflictError extends TaskRepositoryError {
  ConflictError({super.error, super.stackTrace});
}

class UnauthorizedError extends TaskRepositoryError {
  UnauthorizedError({super.error, super.stackTrace});
}

class DataBaseError extends TaskRepositoryError {
  DataBaseError({super.error, super.stackTrace});
}
