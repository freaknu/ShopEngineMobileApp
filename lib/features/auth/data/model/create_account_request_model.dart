import 'package:ecommerce_app/features/auth/domain/entity/create_account.dart';

class CreateAccountRequestModel extends CreateAccount {
  CreateAccountRequestModel({
    required super.name,
    required super.email,
    required super.password,
    required super.role,
  });

  static Map<String, dynamic> toJson(CreateAccount data) {
    return {
      "name": data.name,
      "email": data.email,
      "password": data.password,
      "role": List<String>.from(data.role),
    };
  }
}
