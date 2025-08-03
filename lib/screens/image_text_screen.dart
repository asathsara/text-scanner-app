import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:text_extractor_app/components/stroke_text.dart';
import 'package:text_extractor_app/controllers/image_text_controller.dart';
import 'package:text_extractor_app/providers/theme_provider.dart';
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Saved to Firebase")),
      );
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
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const SizedBox(height: 32),
                GestureDetector(
                  onTap: () {
                    Provider.of<ThemeProvider>(
                      context,
                      listen: false,
                    ).toggleTheme();
                  },
                  child: const StrokeText(text: "Image to Text"),
                ),

                const SizedBox(height: 32),
                // Settings Card with Icon
                Align(
                  alignment: Alignment.centerRight,
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    color: Theme.of(context).colorScheme.surface,
                    child: IconButton(
                      icon: const Icon(Icons.settings, size: 28),
                      color: Theme.of(context).colorScheme.primary,
                      onPressed: () {
                        Navigator.of(context).pushNamed('/settings');
                      },
                      tooltip: "Settings",
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
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
