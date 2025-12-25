import 'package:ecommerce_app/features/review/domain/entity/review.dart';

class ReviewModel extends Review {
  ReviewModel({
    required super.id,
    required super.userName,
    required super.description,
    required super.rating,
    required super.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] ?? 0,
      userName: json['userName'] ?? '',
      description: json['description'] ?? '',
      rating: json['rating'] ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'description': description,
      'rating': rating,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  ReviewModel copyWith({
    int? id,
    String? userName,
    String? description,
    int? rating,
    DateTime? createdAt,
  }) {
    return ReviewModel(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      description: description ?? this.description,
      rating: rating ?? this.rating,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}