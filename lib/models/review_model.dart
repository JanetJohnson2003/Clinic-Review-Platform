import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  final String userId;
  final String clinicName;
  final String feedback;
  final double rating;
  final DateTime timestamp;

  ReviewModel({
    required this.userId,
    required this.clinicName,
    required this.feedback,
    required this.rating,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'clinicName': clinicName,
      'feedback': feedback,
      'rating': rating,
      'timestamp': timestamp,
    };
  }

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      userId: map['userId'],
      clinicName: map['clinicName'],
      feedback: map['feedback'],
      rating: (map['rating'] as num).toDouble(),
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }
}
