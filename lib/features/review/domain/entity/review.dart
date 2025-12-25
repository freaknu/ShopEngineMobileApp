class Review {
  final int id;
  final String userName;
  final String description;
  final int rating;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.userName,
    required this.description,
    required this.rating,
    required this.createdAt,
  });
}