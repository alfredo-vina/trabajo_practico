class User {
  final String username;
  final String role;
  final String firstname;
  final String lastname;

  const User({
    required this.username,
    required this.role,
    required this.firstname,
    required this.lastname,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'username': String username,
        'role': String role,
        'firstname': String firstname,
        'lastname': String lastname,
      } =>
        User(
          username: username,
          role: role,
          firstname: firstname,
          lastname: lastname,
        ),
      _ => throw const FormatException('Failed to load user.'),
    };
  }
}