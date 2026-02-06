import 'package:nashik/core/utils/result.dart';

/// Base use case interface
/// All use cases should implement this for consistent behavior
///
/// [Params] - The input parameters (can be a DTO, entity, or simple type)
/// [Type] - The return type (usually an Entity, or Unit for void operations)
///
/// **Important**: Use `Unit` from fpdart instead of `void` for operations that don't return a value.
/// This allows proper type safety with `Result<Unit>` (Either<Failure, Unit>).
abstract class UseCase<Type, Params> {
  /// Execute the use case with given parameters
  /// Returns a [Result<T>] which is an [Either<Failure, T>]
  /// For void operations, use `Result<Unit>` instead of `Result<void>`
  Future<Result<Type>> call(Params params);
}

/// Use case that doesn't require parameters
/// Use this for use cases that don't need any input
///
/// **Important**: Use `Unit` from fpdart instead of `void` for operations that don't return a value.
abstract class UseCaseNoParams<Type> {
  /// Execute the use case without parameters
  /// Returns a [Result<T>] which is an [Either<Failure, T>]
  /// For void operations, use `Result<Unit>` instead of `Result<void>`
  Future<Result<Type>> call();
}
