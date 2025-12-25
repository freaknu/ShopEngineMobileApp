import 'package:ecommerce_app/features/auth/domain/entity/auth_response.dart';

class AuthResponseModel extends AuthResponse {
  AuthResponseModel(
    super.accessToken,
    super.refreshToken,
    super.roles,
    super.userId,
  );

  factory AuthResponseModel.fromJson(Map<String, dynamic> data) {
    return AuthResponseModel(
      data['accessToken'],
      data['refreshToken'],
      List<String>.from(data['roles'] ?? []),
      data['userId'],
    );
  }
}
