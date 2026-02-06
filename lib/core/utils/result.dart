import 'package:fpdart/fpdart.dart';
import 'package:nashik/core/error/exceptions/api_exception.dart';
import 'package:nashik/core/error/exceptions/app_exception.dart';
import 'package:nashik/core/error/exceptions/network_exception.dart';
import 'package:nashik/core/error/exceptions/server_exception.dart';
import 'package:nashik/core/error/exceptions/validation_exception.dart';
import 'package:nashik/core/error/failures/bad_request_failure.dart';
import 'package:nashik/core/error/failures/failure.dart';
import 'package:nashik/core/error/failures/network_failure.dart';
import 'package:nashik/core/error/failures/not_found_failure.dart';
import 'package:nashik/core/error/failures/server_failure.dart';
import 'package:nashik/core/error/failures/unauthorized_failure.dart';
import 'package:nashik/core/error/failures/validation_failure.dart';

/// Type alias for Result - Either<Failure, T>
/// This is the standard return type for use cases and repositories
typedef Result<T> = Either<Failure, T>;

/// Helper function to map exceptions to failures
Failure mapExceptionToFailure(AppException exception) {
  if (exception is ApiException) {
    if (exception.isUnauthorized) {
      return UnauthorizedFailure(message: exception.message);
    }
    if (exception.isNotFound) {
      return NotFoundFailure(message: exception.message);
    }
    if (exception.isBadRequest) {
      return BadRequestFailure(message: exception.message);
    }
    return ServerFailure(
      message: exception.message,
      code: exception.code,
      statusCode: exception.statusCode,
      data: exception.data,
    );
  }
  if (exception is ServerException) {
    return ServerFailure(
      message: exception.message,
      code: exception.code,
      statusCode: exception.statusCode,
      data: exception.data,
    );
  } else if (exception is NetworkException) {
    return NetworkFailure(message: exception.message, code: exception.code);
  } else if (exception is ValidationException) {
    return ValidationFailure(
      message: exception.message,
      code: exception.code,
      errors: exception.errors,
    );
  } else {
    return ServerFailure(
      message: exception.message,
      code: exception.code ?? 'UNKNOWN_ERROR',
    );
  }
}

/// Execute a function and catch exceptions, returning Either<Failure, T>
/// This is the main utility function used in repository implementations
Future<Result<T>> executeWithErrorHandling<T>(
  Future<T> Function() function,
) async {
  try {
    final result = await function();
    return Right(result);
  } on AppException catch (e) {
    return Left(mapExceptionToFailure(e));
  } catch (e) {
    return Left(
      ServerFailure(
        message: 'An unexpected error occurred: ${e.toString()}',
        code: 'UNEXPECTED_ERROR',
      ),
    );
  }
}

/// Execute a synchronous function and catch exceptions, returning Either<Failure, T>
Result<T> executeWithErrorHandlingSync<T>(T Function() function) {
  try {
    final result = function();
    return Right(result);
  } on AppException catch (e) {
    return Left(mapExceptionToFailure(e));
  } catch (e) {
    return Left(
      ServerFailure(
        message: 'An unexpected error occurred: ${e.toString()}',
        code: 'UNEXPECTED_ERROR',
      ),
    );
  }
}

/// Helper function to create a success result
Result<T> success<T>(T value) => Right(value);

/// Helper function to create a failure result
Result<T> failure<T>(Failure failure) => Left(failure);
