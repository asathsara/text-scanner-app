import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:text_extractor_app/components/note_action_button.dart';
import 'package:text_extractor_app/components/note_counter_card.dart';
import 'package:text_extractor_app/components/stroke_text.dart';

class TextEditorScreen extends StatefulWidget {
  const TextEditorScreen({super.key});

  @override
  State<TextEditorScreen> createState() => _TextEditorScreenState();
}

class _TextEditorScreenState extends State<TextEditorScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  int wordCount = 0;
  int charCount = 0;

  void _updateCounts(String text) {
    setState(() {
      charCount = text.length;
      wordCount = text.trim().isEmpty
          ? 0
          : text.trim().split(RegExp(r'\s+')).length;
    });
  }

  void _clearText() {
    _noteController.clear();
    _updateCounts('');
  }

  void _copyText() {
    Clipboard.setData(ClipboardData(text: _noteController.text));
  }

  void _pasteText() async {
    ClipboardData? data = await Clipboard.getData('text/plain');
    if (data != null) {
      _noteController.text += data.text!;
      _updateCounts(_noteController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 32),
            StrokeText(text: "Text Editor"),
            SizedBox(height: 32),
            TextFormField(
              controller: _titleController,
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
              decoration: InputDecoration(
                hintText: "Note Title",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                NoteCounterCard(label: "CHARACTERS", count: charCount),
                const SizedBox(width: 12),
                NoteCounterCard(label: "WORDS", count: wordCount),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    NoteActionButton(
                      icon: Icons.copy,
                      label: "copy",
                      onTap: _copyText,
                    ),
                    NoteActionButton(
                      icon: Icons.paste,
                      label: "paste",
                      onTap: _pasteText,
                    ),
                    NoteActionButton(
                      icon: Icons.clear_all,
                      label: "clear all",
                      onTap: _clearText,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: _noteController,
                onChanged: _updateCounts,
                maxLines: null,
                expands: true,
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
                decoration: InputDecoration(
                  hintText: "Enter your note here…",
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.list),
        onPressed: () {
          // TODO: Implement your functionality
        },
      ),
    );
  }
}
