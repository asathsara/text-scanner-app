import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:text_extractor_app/controllers/text_editor_controller.dart';
import 'package:text_extractor_app/components/note_action_button.dart';
import 'package:text_extractor_app/components/note_counter_card.dart';
import 'package:text_extractor_app/providers/note_provider.dart';
import 'package:text_extractor_app/utils/constants/colors.dart';

class TextEditorScreen extends StatefulWidget {
  const TextEditorScreen({super.key});

  @override
  State<TextEditorScreen> createState() => _TextEditorScreenState();
}

class _TextEditorScreenState extends State<TextEditorScreen> {
  late final TextEditorController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditorController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final noteProvider = Provider.of<NoteProvider>(context);
    controller.titleController.text = noteProvider.title;
    controller.noteController.text= noteProvider.content;
    controller.updateCounts(noteProvider.content);
  }

  Future<void> _handleShare() async {

    // start sharing process
    final result = await controller.shareNote();

    // Check if the user is still mounted before showing a snackbar
    if (!mounted) return;

    final messenger = ScaffoldMessenger.of(context);

    if (result == ShareResultStatus.success) {
      messenger.showSnackBar(
        const SnackBar(content: Text("Shared successfully!")),
      );

    } else if ((await controller.getNoteToShare()).trim().isEmpty) {

      messenger.showSnackBar(const SnackBar(content: Text("Nothing to share")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Text Editor',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: controller.titleController,
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
              decoration: InputDecoration(
                hintText: "Note Title",
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ValueListenableBuilder<int>(
                  valueListenable: controller.charCount,
                  builder: (_, count, __) =>
                      NoteCounterCard(label: "CHARACTERS", count: count),
                ),
                const SizedBox(width: 12),
                ValueListenableBuilder<int>(
                  valueListenable: controller.wordCount,
                  builder: (_, count, __) =>
                      NoteCounterCard(label: "WORDS", count: count),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[800] : MyColors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  NoteActionButton(
                    icon: Icons.copy,
                    label: "copy",
                    onTap: controller.copyText,
                  ),
                  NoteActionButton(
                    icon: Icons.paste,
                    label: "paste",
                    onTap: controller.pasteText,
                  ),
                  NoteActionButton(
                    icon: Icons.clear_all,
                    label: "clear all",
                    onTap: controller.clearText,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: controller.noteController,
                onChanged: controller.updateCounts,
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
        backgroundColor: MyColors.cyanBlue,
        onPressed: _handleShare,
        child: const Icon(Icons.share, color: Colors.white),
      ),
    );
  }
}
