class AuthResponse {
  final int userId;
  final String accessToken;
  final String refreshToken;
  final List<String> roles;
  AuthResponse(this.accessToken, this.refreshToken, this.roles, this.userId);
}
