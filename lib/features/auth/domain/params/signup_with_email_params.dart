/// Parameters for sign-up with email (domain layer, pure Dart).
class SignupWithEmailParams {
  const SignupWithEmailParams({
    required this.email,
    required this.password,
    required this.name,
    this.phone,
  });

  final String email;
  final String password;
  final String name;
  final String? phone;
}
