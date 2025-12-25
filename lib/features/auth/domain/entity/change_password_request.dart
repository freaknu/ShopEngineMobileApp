class ChangePasswordRequest {
  final String token;
  final String email;
  final String newPassword;

  ChangePasswordRequest(this.token, this.email, this.newPassword);
}
