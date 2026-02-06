import 'package:nashik/core/error/failures/failure.dart';

class BadRequestFailure extends Failure {
  const BadRequestFailure({
    required super.message,
    super.code = '400',
  });
}
