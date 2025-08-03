import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:text_extractor_app/services/clipboard_service.dart';
import 'package:text_extractor_app/services/share_service.dart';

class TextEditorController {
  TextEditingController titleController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  ValueNotifier<int> wordCount = ValueNotifier(0);
  ValueNotifier<int> charCount = ValueNotifier(0);

  void updateCounts(String text) {
    charCount.value = text.length;
    wordCount.value = text.trim().isEmpty
        ? 0
        : text.trim().split(RegExp(r'\s+')).length;
  }

  void clearText() {
    noteController.clear();
    updateCounts('');
  }

  Future<void> copyText() async {
    await ClipboardService.copy(noteController.text);
  }

  Future<void> pasteText() async {
    final data = await ClipboardService.paste();
    if (data != null) {
      noteController.text += data;
      updateCounts(noteController.text);
    }
  }

  Future<String> getNoteToShare() async {
    final title = titleController.text.trim();
    final content = noteController.text.trim();
    return '$title\n\n$content';
  }

  Future<ShareResultStatus> shareNote() async {
    final text = await getNoteToShare();
    return await ShareService.shareText(text, title: titleController.text);
  }

  void dispose() {
    titleController.dispose();
    noteController.dispose();
    wordCount.dispose();
    charCount.dispose();
  }
}
