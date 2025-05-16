import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:foreglyc/data/models/auth_model.dart';
import 'package:foreglyc/data/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<SignupEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final response = await authRepository.signUp(
          event.name,
          event.email,
          event.password,
          event.confirmPassword,
        );
        emit(AuthRegistered(response: response));
      } catch (e) {
        emit(_handleError(e));
      }
    });

    on<SigninEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final response = await authRepository.signIn(
          event.email,
          event.password,
        );
        emit(AuthSignedIn(response: response));
      } catch (e) {
        emit(_handleError(e));
      }
    });

    on<VerifyUser>((event, emit) async {
      emit(AuthLoading());
      try {
        final response = await authRepository.verifyEmail(event.code);
        emit(AuthVerified(response: response));
      } catch (e) {
        emit(_handleError(e));
      }
    });

    on<SignOutEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final success = await authRepository.signOut();
        if (success) {
          emit(AuthSignedOut());
        } else {
          emit(const AuthError('Failed to sign out'));
        }
      } catch (e) {
        emit(_handleError(e));
      }
    });
  }

  AuthError _handleError(dynamic error) {
    print('Error in AuthBloc: $error'); // Debugging
    if (error is DioException) {
      if (error.response != null && error.response!.data is Map) {
        final errorMessage =
            error.response!.data['message'] ??
            error.response!.statusMessage ??
            error.message;
        return AuthError(errorMessage.toString());
      } else {
        return AuthError(error.message ?? 'Unknown Dio error occurred');
      }
    } else if (error is Exception) {
      return AuthError(error.toString());
    } else {
      return const AuthError('An unknown error occurred');
    }
  }
}
