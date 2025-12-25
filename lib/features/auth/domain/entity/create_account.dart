class CreateAccount {
  final String name;
  final String email;
  final String password;
  final List<String> role;

  CreateAccount({
    required this.name,
    required this.email,
    required this.password,
    required this.role,
  });
}