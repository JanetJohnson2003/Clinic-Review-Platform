import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/review_model.dart';

class ReviewService {
  final CollectionReference reviewsCollection =
      FirebaseFirestore.instance.collection('reviews');

  Stream<List<ReviewModel>> getReviews() {
    return reviewsCollection
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ReviewModel.fromMap(doc.data() as Map<String, dynamic>))
            .toList());
  }

  Future<void> addReview(ReviewModel review) async {
    await reviewsCollection.add(review.toMap());
  }
}
