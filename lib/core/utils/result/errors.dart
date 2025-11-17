enum ErrorType {
  // Auth
  authEmailAlreadyInUse,
  invalidEmail,
  weakPassword,
  invalidCredentials,
  
  // Default
  generic,
  connection,
  notFound,
  uniqueFiledsFuplicated,
}

class IError {
  final ErrorType errorType;
  final String message;

  IError({
    this.errorType = ErrorType.generic,
    required this.message
  });

  String getErrorMessage() {
    return message;
  }

  String defaultError() {
    switch (errorType) {
      case ErrorType.connection:
        return "Connection error";
      default:
        return "Generic error";
    }
  }
}

class AuthResultError extends IError {
  AuthResultError({super.errorType, required super.message}); // Super parameter usado aqui.

  @override
  String getErrorMessage() {
    switch (errorType) {
      case ErrorType.authEmailAlreadyInUse:
        return "Email already in use";
      case ErrorType.invalidEmail:
        return "Invalid email format";
      case ErrorType.weakPassword:
        return "The password must have at least 6 characters";
      default:
        return defaultError();
    }
  }
}

class CustomerError extends IError {
  CustomerError({super.errorType, required super.message}); // Super parameter usado aqui.

  @override
  String getErrorMessage() {
    return message;
  }
}