import 'package:foreglyc/data/models/auth_model.dart';

abstract class AuthRepository {
  Future<SignupResponse> signUp(
    String fullName,
    String email,
    String password,
    String confirmPassword,
  );

  Future<SigninResponse> signIn(String email, String password);

  Future<VerificationResponse> verifyEmail(String code);

  Future<bool> resendVerificationEmail();

  Future<bool> signOut();
}
