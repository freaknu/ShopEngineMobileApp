import 'package:ecommerce_app/features/auth/domain/entity/auth_response.dart';
import 'package:ecommerce_app/features/auth/domain/entity/change_password_request.dart';
import 'package:ecommerce_app/features/auth/domain/entity/create_account.dart';
import 'package:ecommerce_app/features/auth/domain/entity/login_account.dart';
import 'package:ecommerce_app/features/auth/domain/entity/verifyotp_request.dart';

abstract class AuthRepository {
  Future<AuthResponse> signUp(CreateAccount data);
  Future<AuthResponse> login(LoginAccount data);
  Future<String> verifyOtp(VerifyotpRequest data);
  Future<String> sendCode(String email);
  Future<String> changePassword(ChangePasswordRequest data);
}
