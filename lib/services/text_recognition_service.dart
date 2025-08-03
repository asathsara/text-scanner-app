import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class TextRecognitionService {
  final TextRecognizer _recognizer = TextRecognizer();

  // Recognizes text from the given image file.
  Future<String> recognizeText(File imageFile) async {
    final inputImage = InputImage.fromFilePath(imageFile.path);
    final recognized = await _recognizer.processImage(inputImage);
    return recognized.text;
  }

 // Closes the recognizer to free up resources.
  void dispose() {
    _recognizer.close();
  }
}
