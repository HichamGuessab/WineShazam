class Note {
  final int id;
  final String comment;
  final double rating;
  final int wine;
  final int user;
  final bool enabled;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Note({
    required this.id,
    required this.comment,
    required this.rating,
    required this.wine,
    required this.user,
    required this.enabled,
    required this.createdAt,
    required this.updatedAt,
  });
}