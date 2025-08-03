import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/scanned_text.dart';

class FirebaseService {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  // save scanned text to Firestore
  Future<void> saveNote(Note note) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("User not authenticated");

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('scanned_texts')
        .add(note.toJson());
  }
}
