/// Parameters for verify email OTP (domain layer, pure Dart).
class VerifyEmailParams {
  const VerifyEmailParams({
    required this.token,
    required this.email,
  });

  final String token;
  final String email;
}
