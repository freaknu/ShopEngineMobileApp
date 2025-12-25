import 'package:ecommerce_app/core/usecase/usecase.dart';
import 'package:ecommerce_app/features/auth/domain/entity/verifyotp_request.dart';
import 'package:ecommerce_app/features/auth/domain/repository/auth_repository.dart';

class VerifyOtpUsecase implements Usecase<String, VerifyotpRequest> {
  final AuthRepository authRepository;

  VerifyOtpUsecase(this.authRepository);
  @override
  Future<String> call(VerifyotpRequest params) {
    return authRepository.verifyOtp(params);
  }
}
