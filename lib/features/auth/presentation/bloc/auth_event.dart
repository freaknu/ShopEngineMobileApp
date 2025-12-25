import 'package:ecommerce_app/features/auth/domain/entity/change_password_request.dart';
import 'package:ecommerce_app/features/auth/domain/entity/create_account.dart';
import 'package:ecommerce_app/features/auth/domain/entity/login_account.dart';
import 'package:ecommerce_app/features/auth/domain/entity/verifyotp_request.dart';

abstract class AuthEvent {}

class SignupEvent extends AuthEvent {
  final CreateAccount data;

  SignupEvent(this.data);
}

class LoginEvent extends AuthEvent {
  final LoginAccount data;
  LoginEvent(this.data);
}

class VerifyOtp extends AuthEvent {
  final VerifyotpRequest data;
  VerifyOtp(this.data);
}

class SendOtp extends AuthEvent {
  final String data;
  SendOtp(this.data);
}

class ChangePassword extends AuthEvent {
  final ChangePasswordRequest data;
  ChangePassword(this.data);
}
