import 'package:freezed_annotation/freezed_annotation.dart';

part 'signup_request.freezed.dart';

@freezed
class SignupRequest with _$SignupRequest {
  const factory SignupRequest({
    required String email,
    String? phone,
    required String name,
    required String accessToken,
  }) = _SignupRequest;
}
