abstract class AuthenticationEvent {}

class LoginEvent extends AuthenticationEvent {
  final String email;
  final String password;

  LoginEvent({required this.email, required this.password});
}

class SignupEvent extends AuthenticationEvent {
  final String email;
  final String password;

  SignupEvent({required this.email, required this.password});
}

class ForgotPasswordEvent extends AuthenticationEvent {
  final String email;

  ForgotPasswordEvent({required this.email});
}

class LogoutEvent extends AuthenticationEvent {}
