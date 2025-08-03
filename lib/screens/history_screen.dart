import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:text_extractor_app/components/history_item_card.dart';
import 'package:text_extractor_app/controllers/history_controller.dart';
import 'package:text_extractor_app/home_screen.dart';
import 'package:text_extractor_app/providers/note_provider.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late final HistoryController _controller;

  @override
  void initState() {
    super.initState();
    _controller = HistoryController();
  }

  Future<void> _confirmAndDelete(BuildContext context, String docId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete this note?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final success = await _controller.deleteHistoryItem(docId);
      if (success) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Note deleted')));
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to delete note')),
          );
        }
      }
    }
  }

  DateTime _parseDate(String dateStr) {
    try {
      return DateFormat('yyyy-MM-dd HH:mm').parse(dateStr);
    } catch (_) {
      return DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    // get the history stream from the controller
    final stream = _controller.getHistoryStream();

    if (stream == null) {
      return const Center(child: Text("Oops! No history found."));
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'History',
          style: TextStyle(fontWeight: FontWeight.bold),
        )
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: stream,
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
                      final data = docs[index].data() as Map<String, dynamic>?;

                      if (data == null) return const SizedBox();

                      return GestureDetector(
                        onTap: () {
                          Provider.of<NoteProvider>(
                            context,
                            listen: false,
                          ).setNote(data['title'], data['text']);

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
}
