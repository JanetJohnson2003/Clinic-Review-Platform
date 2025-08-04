import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final _clinicController = TextEditingController();
  final _feedbackController = TextEditingController();
  double _rating = 3.0;

  String? _editingDocId;

  void _submitReview() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final clinic = _clinicController.text.trim();
    final feedback = _feedbackController.text.trim();

    if (clinic.isEmpty || feedback.isEmpty) return;

    final data = {
      'clinicName': clinic,
      'feedback': feedback,
      'rating': _rating,
      'userId': user.uid,
      'timestamp': Timestamp.now(),
    };

    if (_editingDocId == null) {
      await FirebaseFirestore.instance.collection('reviews').add(data);
    } else {
      await FirebaseFirestore.instance
          .collection('reviews')
          .doc(_editingDocId)
          .update(data);
      _editingDocId = null;
    }

    _clinicController.clear();
    _feedbackController.clear();
    setState(() => _rating = 3.0);
  }

  void _editReview(DocumentSnapshot doc) {
    setState(() {
      _clinicController.text = doc['clinicName'];
      _feedbackController.text = doc['feedback'];
      _rating = doc['rating'];
      _editingDocId = doc.id;
    });
  }

  void _deleteReview(String id) {
    FirebaseFirestore.instance.collection('reviews').doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Clinic Reviews',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => FirebaseAuth.instance.signOut(),
          )
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/review.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
          SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _buildContent(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.85),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 4),
              )
            ],
          ),
          child: Column(
            children: [
              TextField(
                controller: _clinicController,
                decoration: InputDecoration(
                  labelText: 'Clinic/Practitioner Name',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _feedbackController,
                decoration: InputDecoration(
                  labelText: 'Your Feedback',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text('Rating:'),
                  Expanded(
                    child: Slider(
                      value: _rating,
                      onChanged: (val) => setState(() => _rating = val),
                      min: 1,
                      max: 5,
                      divisions: 4,
                      label: _rating.toStringAsFixed(1),
                    ),
                  ),
                  Text(_rating.toStringAsFixed(1)),
                ],
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: _submitReview,
                icon: Icon(_editingDocId == null ? Icons.send : Icons.update),
                label: Text(_editingDocId == null ? "Submit Review" : "Update Review"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          "All Reviews",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('reviews')
              .orderBy('timestamp', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }
            final docs = snapshot.data!.docs;
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final doc = docs[index];
                return Card(
                  color: Colors.white.withOpacity(0.85),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text(
                      doc['clinicName'],
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.teal),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(doc['feedback']),
                        Text("Rating: ${doc['rating']}"),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.indigo),
                          onPressed: () => _editReview(doc),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteReview(doc.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        )
      ],
    );
  }
}
