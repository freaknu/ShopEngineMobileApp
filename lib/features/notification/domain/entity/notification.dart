class Notification {
  final String id;
  final String title;
  final String description;
  final int userId;
  final String iconUrl;
  final String aboutPage;
  final DateTime receivedAt;
  final DateTime createdAt;

  Notification({
    required this.id,
    required this.title,
    required this.description,
    required this.userId,
    required this.iconUrl,
    required this.aboutPage,
    required this.receivedAt,
    required this.createdAt,
  });
}
