import 'package:nashik/core/error/failures/failure.dart';

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({
    super.message = 'Session expired. Please sign in again.',
    super.code = '401',
  });
}
