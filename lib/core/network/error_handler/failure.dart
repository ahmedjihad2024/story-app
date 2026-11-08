import 'error_handler.dart';

sealed class Failure {
  const Failure();
}

class ServerError extends Failure {
  final String? message;
  const ServerError({this.message});
}

class UnexpectedError extends Failure {
  final String? message;
  const UnexpectedError({this.message});
}

class NoInternetConnection extends Failure {
  const NoInternetConnection();
}

class CustomLocalError extends Failure {
  final LocalErrorType error;
  const CustomLocalError({required this.error});
}

typedef CustomDioLocalError = CustomLocalError;

class CustomServerError extends Failure {
  final ApiErrorType error;
  const CustomServerError({required this.error});
}
