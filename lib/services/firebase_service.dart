import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/scanned_text.dart';

class FirebaseService {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  FirebaseService({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  /// Save scanned note to user's Firestore history
  Future<void> saveNote(Note note) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("User not authenticated");

    await _userNotesRef(user.uid).add(note.toJson());
  }

  /// Stream user's scanned text history ordered by date (latest first)
  Stream<QuerySnapshot> getUserHistoryStream() {
    final user = _auth.currentUser;
    if (user == null) throw Exception("User not authenticated");

    return _userNotesRef(user.uid)
        .orderBy('date', descending: true)
        .snapshots();
  }

  /// Delete a specific history note by document ID
  Future<void> deleteNote(String docId) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("User not authenticated");

    await _userNotesRef(user.uid).doc(docId).delete();
  }

  ///  helper: reference to scanned_texts collection
  CollectionReference<Map<String, dynamic>> _userNotesRef(String userId) {
    return _firestore.collection('users').doc(userId).collection('scanned_texts');
  }
}
