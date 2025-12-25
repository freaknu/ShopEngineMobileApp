import 'package:ecommerce_app/features/auth/domain/entity/login_account.dart';

class LoginAccountRequestModel extends LoginAccount {
  LoginAccountRequestModel(super.email, super.password);

  static Map<String, dynamic> toJson(LoginAccountRequestModel data) {
    return Map.of({"email": data.email, "password": data.password});
  }
}
