import 'package:ecommerce_app/core/usecase/usecase.dart';
import 'package:ecommerce_app/features/auth/domain/entity/auth_response.dart';
import 'package:ecommerce_app/features/auth/domain/entity/login_account.dart';
import 'package:ecommerce_app/features/auth/domain/repository/auth_repository.dart';

class LoginAccountUsecase extends Usecase<AuthResponse, LoginAccount> {
  final AuthRepository authRepository;
  LoginAccountUsecase(this.authRepository);
  @override
  Future<AuthResponse> call(LoginAccount params) {
    return authRepository.login(params);
  }
}
