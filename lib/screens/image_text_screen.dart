import 'package:flutter/material.dart';
import 'package:text_extractor_app/components/stroke_text.dart';

class ImageTextScreen extends StatefulWidget {
  const ImageTextScreen({super.key});

  @override
  State<ImageTextScreen> createState() => _ImageTextScreenState();
}

class _ImageTextScreenState extends State<ImageTextScreen> {
  String extractedText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 32),
            StrokeText(text: "Image to Text"),
            SizedBox(height: 32),
            // Image Upload Box
            GestureDetector(
              onTap: () {
                // TODO: Implement image picker
              },
              child: Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[100],
                ),
                child: const Center(child: Text("Tap to upload image")),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  // TODO: Implement text extraction
                  setState(() {
                    extractedText = "Example extracted text goes here...";
                  });
                },
                child: const Text("Extract Text"),
              ),
            ),
            const SizedBox(height: 24),

            // Extracted Text Display
            Expanded(
              child: TextFormField(
                maxLines: null,
                readOnly: true,
                initialValue: extractedText,
                decoration: InputDecoration(
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
