import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:text_extractor_app/components/stroke_text.dart';

class ImageTextScreen extends StatefulWidget {
  const ImageTextScreen({super.key});

  @override
  State<ImageTextScreen> createState() => _ImageTextScreenState();
}

class _ImageTextScreenState extends State<ImageTextScreen> {
  XFile? _imageFile;
  final TextRecognizer _textRecognizer = TextRecognizer();
  final TextEditingController _textController = TextEditingController();
  bool _isProcessing = false;

  @override
  void dispose() {
    _textRecognizer.close();
    _textController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        setState(() {
          _imageFile = pickedFile;
          _textController.clear(); // Clear previous results
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to pick image: $e')));
    }
  }

  Future<void> _extractText() async {
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image first.')),
      );
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      final inputImage = InputImage.fromFilePath(_imageFile!.path);
      final RecognizedText recognizedText = await _textRecognizer.processImage(
        inputImage,
      );

      final extractedText = recognizedText.text;
      _textController.text = extractedText;

      if (extractedText.trim().isNotEmpty) {
        await _saveToFirebase(extractedText);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to extract text: $e')));
    }

    setState(() => _isProcessing = false);
  }

  Future<void> _saveToFirebase(String text) async {
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(now);
    final words = text.split(RegExp(r'\s+'));
    final title = words.take(3).join(' '); // First 3 words as title

    try {
      final doc = await FirebaseFirestore.instance
          .collection('extracted_texts')
          .add({'title': title, 'date': formattedDate, 'text': text});

      print('Saved to Firebase with ID: ${doc.id}');

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Saved to Firebase")));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to save: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            const StrokeText(text: "Image to Text"),
            const SizedBox(height: 32),
            // Image Upload Box
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[200],
                ),
                child: _imageFile != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(11),
                        child: Image.file(
                          File(_imageFile!.path),
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_photo_alternate_outlined,
                              size: 40,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 8),
                            Text("Tap to upload image"),
                          ],
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton(
                onPressed: _isProcessing || _imageFile == null
                    ? null
                    : _extractText,
                child: _isProcessing
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : const Text("Extract Text"),
              ),
            ),
            const SizedBox(height: 24),

            // Extracted Text Display
            Expanded(
              child: TextFormField(
                controller: _textController,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  labelText: "Extracted Text",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
