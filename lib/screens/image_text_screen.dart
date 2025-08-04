import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:text_extractor_app/components/image_upload_card.dart';
import 'package:text_extractor_app/controllers/image_text_controller.dart';
import 'package:text_extractor_app/services/firebase_service.dart';
import 'package:text_extractor_app/services/text_recognition_service.dart';

class ImageTextScreen extends StatefulWidget {
  const ImageTextScreen({super.key});

  @override
  State<ImageTextScreen> createState() => _ImageTextScreenState();
}

class _ImageTextScreenState extends State<ImageTextScreen> {
  XFile? _imageFile;
  bool _isProcessing = false;

  final TextEditingController _textController = TextEditingController();
  late final ImageTextController _controller;

  @override
  void initState() {
    super.initState();

    // Initialize the ImageTextController with Firebase and Text Recognition services
    _controller = ImageTextController(
      FirebaseService(),
      TextRecognitionService(),
    );
  }

  @override
  void dispose() {
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
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to pick image: $e')));
      }
    }
  }

  Future<void> _scanText() async {
    // Ensure an image is selected before processing
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
      final file = File(_imageFile!.path);

      // Use the controller to process the image and scan text
      final note = await _controller.processImage(file);

      _textController.text = note.text;

      if (note.text.trim().isNotEmpty) {
        await _controller.saveToFirebase(note);
      }

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Saved to Firebase")));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to scan text: $e')));
      }
    }

    setState(() => _isProcessing = false);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Image to Text',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).pushNamed('/settings');
            },
            tooltip: "Settings",
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            // Image Upload Box
            ImageUploadCard(imageFile: _imageFile, onTap: _pickImage),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton(
                onPressed: _isProcessing || _imageFile == null
                    ? null
                    : _scanText,
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
              child: TextField(
                controller: _textController,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
                decoration: InputDecoration(
                  hintText: "Extracted Text",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
