abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {
  final String loadingMessage;
  AuthLoading(this.loadingMessage);
}

class AuthSuccess extends AuthState {
  final String successMessage;

  AuthSuccess(this.successMessage);
}

class AuthFailure extends AuthState {
  final String failureMessage;

  AuthFailure(this.failureMessage);
}
