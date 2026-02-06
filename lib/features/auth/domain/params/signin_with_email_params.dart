/// Parameters for sign-in with email (domain layer, pure Dart).
class SigninWithEmailParams {
  const SigninWithEmailParams({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;
}
