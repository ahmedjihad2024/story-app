// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../base_response.dart';
import 'failure.dart';
import 'package:http/http.dart' as http;

Future<Either<Failure, T>> fastHandler<R, T>({
  required Future<R> Function() request,
  required T Function(R response) mapper,
}) async {
  try {
    final response = await request();
    if (response is BasicResponse && !response.success) {
      return Left(ServerError(message: response.message));
    }
    return Right(mapper(response));
  } catch (e) {
    return Left(e.handle);
  }
}

extension ErrorHandler on Object {
  Failure get handle => switch (this) {
    final Failure f => f,
    final AuthException e => _handleAuthException(e),
    final PostgrestException e => _handlePostgrest(e),
    final StorageException e => ServerError(message: e.message),
    // final FunctionException e => ServerError(
    //   message: e.reasonPhrase ?? e.details?.toString() ?? 'Function error',
    // ),
    final SocketException _ => const NoInternetConnection(),
    final http.ClientException _ => const NoInternetConnection(),
    final TimeoutException _ => const CustomLocalError(
      error: LocalErrorType.CONNECTION_TIMEOUT,
    ),
    _ => UnexpectedError(message: toString()),
  };
}

Failure _handlePostgrest(PostgrestException e) => switch (e.errorCode) {
  '42501' => ServerError(
    message: 'You do not have permission',
  ), 
  'PGRST116' => ServerError(message: 'Not found'), 
  '23505' => ServerError(message: 'Already exists'), 
  _ => ServerError(message: e.message),
};

Failure _handleAuthException(AuthException e) {
  final statusCode = e is AuthApiException ? e.statusCode : null;
  final apiError = ApiErrorType.from(statusCode, e.message);
  if (apiError != null) {
    return CustomServerError(error: apiError);
  }
  return ServerError(message: e.message);
}

enum LocalErrorType {
  CONNECTION_TIMEOUT('Connection timed out.'),
  SEND_TIMEOUT('Request timed out while sending.'),
  RECEIVE_TIMEOUT('Response timed out while receiving.'),
  CANCEL('Request was cancelled.'),
  UNKNOWN('Something went wrong. Please try again.');

  final String message;
  const LocalErrorType(this.message);
}

enum ApiErrorType {
  USER_NOT_CONFIRMED(401, 'User is not confirmed.'),
  UNAUTHORIZED(401, 'Unauthorized'),
  EMAIL_TAKEN(400, 'An account with the given email already exists.'),
  INCORRECT_CREDENTIALS(400, 'Invalid email or password.'),
  INCORRECT_CREDENTIALS_401(401, 'Incorrect username or password.'),
  INVALID_CODE(400, 'Invalid code provided, please request a code again.'),
  INVALID_REFRESH_TOKEN(400, 'Invalid Refresh Token'),
  EMAIL_NOT_VERIFIED(
    400,
    'Email not verified, please verify your email first.',
  );

  final int statusCode;
  final String message;
  const ApiErrorType(this.statusCode, this.message);

  static ApiErrorType? from(int? statusCode, String message) {
    final lower = message.toLowerCase().trim();
    for (final e in values) {
      if ((e.statusCode == statusCode || statusCode == null) &&
          (e.message.toLowerCase() == lower ||
              lower.contains(e.message.toLowerCase()))) {
        return e;
      }
    }
    return null;
  }
}
