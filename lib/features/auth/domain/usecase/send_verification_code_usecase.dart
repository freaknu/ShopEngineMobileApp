import 'package:ecommerce_app/core/usecase/usecase.dart';
import 'package:ecommerce_app/features/auth/domain/repository/auth_repository.dart';

class SendVerificationCodeUsecase implements Usecase<String, String> {
  final AuthRepository authRepository;

  SendVerificationCodeUsecase(this.authRepository);
  @override
  Future<String> call(String params) {
    return authRepository.sendCode(params);
  }
}
