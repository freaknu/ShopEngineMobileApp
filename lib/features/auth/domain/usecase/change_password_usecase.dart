import 'package:ecommerce_app/core/usecase/usecase.dart';
import 'package:ecommerce_app/features/auth/domain/entity/change_password_request.dart';
import 'package:ecommerce_app/features/auth/domain/repository/auth_repository.dart';

class ChangePasswordUsecase extends Usecase<String, ChangePasswordRequest> {
  final AuthRepository authRepository;
  ChangePasswordUsecase(this.authRepository);
  @override
  Future<String> call(ChangePasswordRequest params) {
    return authRepository.changePassword(params);
  }
}
