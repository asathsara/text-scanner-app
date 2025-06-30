import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:text_extractor_app/components/note_action_button.dart';
import 'package:text_extractor_app/components/note_counter_card.dart';
import 'package:text_extractor_app/components/stroke_text.dart';
import 'package:text_extractor_app/providers/note_provider.dart';
import 'package:text_extractor_app/utils/constants/colors.dart';

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    final noteProvider = Provider.of<NoteProvider>(context);
    _titleController.text = noteProvider.title;
    _noteController.text = noteProvider.content;
    _updateCounts(noteProvider.content);
  }

  void _shareNote() async {
    final title = _titleController.text.trim();
    final content = _noteController.text.trim();
    final contentToShare = '$title\n\n$content';

    if (contentToShare.isNotEmpty) {
      final result = await SharePlus.instance.share(
        ShareParams(
          text: contentToShare,
          subject: title.isEmpty ? null : title,
        ),
      );

      if (result.status == ShareResultStatus.success) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("Shared successfully!")));
        }
      }
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Nothing to share")));
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
                color: isDark ? Colors.grey[800] : MyColors.white,
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
                textAlignVertical: TextAlignVertical.top, 
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
        shape: const CircleBorder(),
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[800]
            : MyColors.lightBlack,
        onPressed: _shareNote,
        child: const Icon(Icons.share, color: Colors.white),
      ),
    );
  }
}
