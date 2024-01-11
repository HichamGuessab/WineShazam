class User {
  final int id;
  final String username;
  final String email;
  final bool enabled;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const User( {
    required this.id,
    required this.username,
    required this.email,
    required this.enabled,
    required this.createdAt,
    required this.updatedAt,
  });
}