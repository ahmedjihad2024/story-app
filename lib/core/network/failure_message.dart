import 'error_handler/failure.dart';

extension FailureMessage on Failure {
  String get message => switch (this) {
        ServerError(:final message) => message ?? 'Server Error',
        UnexpectedError(:final message) => message ?? 'Unexpected Error',
        NoInternetConnection() => 'No internet connection',
        CustomLocalError(:final error) => error.message,
        CustomServerError(:final error) => error.message,
      };
}
