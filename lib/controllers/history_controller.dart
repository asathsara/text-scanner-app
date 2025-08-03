import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:text_extractor_app/services/firebase_service.dart';

class HistoryController {
  final FirebaseService _service;
  final FirebaseAuth _auth;

  HistoryController({FirebaseService? service, FirebaseAuth? auth})
      : _service = service ?? FirebaseService(),
        _auth = auth ?? FirebaseAuth.instance;

  String? get currentUserId => _auth.currentUser?.uid;

  Stream<QuerySnapshot>? getHistoryStream() {

    // Ensure the user is authenticated before accessing history
    final userId = currentUserId;
    if (userId == null) return null;

    // Fetch the history stream for the authenticated user
    return _service.getUserHistoryStream();
  }

  Future<bool> deleteHistoryItem(String docId) async {
    final userId = currentUserId;
    if (userId == null) return false;

    try {
      await _service.deleteNote(docId);
      return true;
    } catch (_) {
      return false;
    }
  }
}
