part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthRegistered extends AuthState {
  final SignupResponse response;

  const AuthRegistered({required this.response});

  @override
  List<Object> get props => [response];
}

class AuthVerified extends AuthState {
  final VerificationResponse response;

  const AuthVerified({required this.response});

  @override
  List<Object> get props => [response];
}

class AuthSignedIn extends AuthState {
  final SigninResponse response;

  const AuthSignedIn({required this.response});

  @override
  List<Object> get props => [response];
}

class AuthSignedOut extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object> get props => [message];
}
