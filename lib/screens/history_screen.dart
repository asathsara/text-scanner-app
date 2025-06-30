import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:text_extractor_app/components/history_item_card.dart';
import 'package:text_extractor_app/components/stroke_text.dart';
import 'package:text_extractor_app/home_screen.dart';
import 'package:text_extractor_app/providers/note_provider.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

void _confirmAndDelete(BuildContext context, String docId) async {
  final confirm = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Delete this note?'),
      content: const Text('This action cannot be undone.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          child: Text('Delete'),
        ),
      ],
    ),
  );

  if (confirm == true) {
    FirebaseFirestore.instance
        .collection('extracted_texts')
        .doc(docId)
        .delete();

    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Note deleted')));
    }
  }
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            const StrokeText(text: "History"),
            const SizedBox(height: 24),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('extracted_texts')
                    .orderBy('date', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("No history yet."));
                  }

                  final docs = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final data = docs[index].data() as Map<String, dynamic>;

                      return GestureDetector(
                        onTap: () {
                          Provider.of<NoteProvider>(
                            context,
                            listen: false,
                          ).setNote(data['title'], data['text']);

                          // Switch to Text Editor tab (index 2)
                          final homePageState = context
                              .findAncestorStateOfType<MyHomePageState>();
                          homePageState?.navigateToPage(2);
                        },
                        onLongPress: () =>
                            _confirmAndDelete(context, docs[index].id),
                        child: HistoryItemCard(
                          title: data['title'] ?? 'No Title',
                          content: data['text'] ?? '',
                          date: _parseDate(data['date']),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Convert string date to DateTime
  DateTime _parseDate(String dateStr) {
    try {
      return DateFormat('yyyy-MM-dd HH:mm').parse(dateStr);
    } catch (e) {
      return DateTime.now();
    }
  }
}
