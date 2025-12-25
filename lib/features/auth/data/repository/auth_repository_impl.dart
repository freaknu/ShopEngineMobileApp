import 'package:ecommerce_app/features/auth/data/datasource/remote/auth_api_service.dart';
import 'package:ecommerce_app/features/auth/data/model/create_account_request_model.dart';
import 'package:ecommerce_app/features/auth/data/model/login_account_request_model.dart';
import 'package:ecommerce_app/features/auth/domain/entity/auth_response.dart';
import 'package:ecommerce_app/features/auth/domain/entity/change_password_request.dart';
import 'package:ecommerce_app/features/auth/domain/entity/create_account.dart';
import 'package:ecommerce_app/features/auth/domain/entity/login_account.dart';
import 'package:ecommerce_app/features/auth/domain/entity/verifyotp_request.dart';
import 'package:ecommerce_app/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApiService apiService;
  AuthRepositoryImpl(this.apiService);
  @override
  Future<String> changePassword(ChangePasswordRequest data) {
    return apiService.changePassword(data);
  }

  @override
  Future<AuthResponse> login(LoginAccount data) {
    return apiService.loginAccount(
      LoginAccountRequestModel(data.email, data.password),
    );
  }

  @override
  Future<String> sendCode(String email) {
    return apiService.sendVerificationCode(email);
  }

  @override
  Future<AuthResponse> signUp(CreateAccount data) {
    return apiService.createAccount(
      CreateAccountRequestModel(
        name: data.name,
        email: data.email,
        password: data.password,
        role: data.role,
      ),
    );
  }

  @override
  Future<String> verifyOtp(VerifyotpRequest data) {
    return apiService.verifyCode(data);
  }
}
