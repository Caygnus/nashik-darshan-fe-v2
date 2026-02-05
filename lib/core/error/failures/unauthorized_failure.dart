import 'package:nashik/core/error/failures/failure.dart';

/// Failure for 401 Unauthorized (session expiry, invalid credentials, or missing auth).
/// Override [message] for context-specific text (e.g. login failure vs session expired).
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({
    super.message = 'Unauthorized. Please sign in again.',
    super.code = '401',
  });
}
