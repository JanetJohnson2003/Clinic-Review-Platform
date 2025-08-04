import 'package:flutter/material.dart';
import '../models/review_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReviewCard extends StatelessWidget {
  final ReviewModel review;
  final VoidCallback? onDelete;

  const ReviewCard({Key? key, required this.review, this.onDelete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        title: Text(review.feedback),
        subtitle: Text("Rating: ${review.rating.toStringAsFixed(1)}"),
        trailing: user?.uid == review.userId
            ? IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: onDelete,
              )
            : null,
      ),
    );
  }
}
