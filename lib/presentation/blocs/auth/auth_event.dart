part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SignupEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String confirmPassword;

  SignupEvent({
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  @override
  List<Object> get props => [name, email, password];
}

class SigninEvent extends AuthEvent {
  final String email;
  final String password;

  SigninEvent({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class VerifyUser extends AuthEvent {
  final String code;

  VerifyUser({required this.code});

  @override
  List<Object> get props => [code];
}

class SignOutEvent extends AuthEvent {}
