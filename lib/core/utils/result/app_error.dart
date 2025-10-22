abstract class AppError {
  final String? message;
  final Object? throwable;

  const AppError({this.message, this.throwable});

  @override
  String toString() => 'AppError';
}

class NetworkError extends AppError {
  const NetworkError({super.message, super.throwable});
  @override
  String toString() => 'NetworkError: $message';
}

class GenericError extends AppError {
  const GenericError({super.message, super.throwable});
  @override
  String toString() => 'GenericError: $message';
}

class NotFoundError extends AppError {
  const NotFoundError({super.message, super.throwable});
  @override
  String toString() => 'NotFoundError: $message';
}

class UserAlreadyExistsError extends AppError {
  const UserAlreadyExistsError({super.message, super.throwable});
  @override
  String toString() => 'UserAlreadyExistsError: $message';
}

class InvalidCredentialsError extends AppError {
  const InvalidCredentialsError({super.message, super.throwable});
  @override
  String toString() => 'InvalidCredentialsError: $message';
}

class InvalidLogoutError extends AppError {
  const InvalidLogoutError({super.message, super.throwable});
  @override
  String toString() => 'InvalidLogoutError: $message';
}
