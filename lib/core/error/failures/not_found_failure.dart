import 'package:nashik/core/error/failures/failure.dart';

class NotFoundFailure extends Failure {
  const NotFoundFailure({
    super.message = 'Resource not found.',
    super.code = '404',
  });
}
