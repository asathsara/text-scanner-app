import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryService {
  final FirebaseFirestore _firestore;

  HistoryService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;


  // Save a note to the user's history
  Stream<QuerySnapshot> getUserHistoryStream(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('scanned_texts')
        .orderBy('date', descending: true)
        .snapshots();
  }

  // Delete a specific history item
  Future<void> deleteHistoryItem(String userId, String docId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('scanned_texts')
        .doc(docId)
        .delete();
  }
}
