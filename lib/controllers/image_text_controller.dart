import 'dart:io';
import 'package:intl/intl.dart';
import '../models/scanned_text.dart';
import '../services/firebase_service.dart';
import '../services/text_recognition_service.dart';

class ImageTextController {
  final FirebaseService _firebaseService;
  final TextRecognitionService _textRecognitionService;

  ImageTextController(this._firebaseService, this._textRecognitionService);

  Future<Note> processImage(File imageFile) async {

    final fullText = await _textRecognitionService.recognizeText(imageFile);
    final title = "Summary of Scanned Text";
    final date = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());

    return Note(title: title, text: fullText, date: date);
  }

  
  Future<void> saveToFirebase(Note note) async {
    await _firebaseService.saveNote(note);
  }
}
