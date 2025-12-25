import 'package:ecommerce_app/core/usecase/usecase.dart';
import 'package:ecommerce_app/features/auth/domain/entity/auth_response.dart';
import 'package:ecommerce_app/features/auth/domain/entity/create_account.dart';
import 'package:ecommerce_app/features/auth/domain/repository/auth_repository.dart';

class CreateAccountUsecase implements Usecase<AuthResponse, CreateAccount> {
  final AuthRepository authRepository;
  CreateAccountUsecase(this.authRepository);
  @override
  Future<AuthResponse> call(CreateAccount params) {
    return authRepository.signUp(params);
  }
}
