import 'package:freezed_annotation/freezed_annotation.dart';

part 'signup_response.freezed.dart';

@freezed
class SignupResponse with _$SignupResponse {
  const factory SignupResponse({
    required String id,
    required String accessToken,
  }) = _SignupResponse;
}
