import 'package:flutter/material.dart';
import 'package:text_extractor_app/components/history_item_card.dart';
import 'package:text_extractor_app/components/stroke_text.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();

  
}

class _HistoryScreenState extends State<HistoryScreen> {
  final List<Map<String, dynamic>> historyItems = [
    {
      'title': 'Meeting Notes',
      'content': 'Discussed quarterly revenue and marketing strategy.\nNext meeting is scheduled next week.',
      'date': DateTime.now().subtract(const Duration(hours: 3)),
    },
    {
      'title': 'Shopping List',
      'content': 'Milk, Bread, Eggs, Coffee, Orange Juice.\nPick up before 6 PM.',
      'date': DateTime.now().subtract(const Duration(days: 1)),
    },
    {
      'title': 'Daily Journal',
      'content': 'Today I started building a Flutter app for OCR...\nI learned about using the Google Fonts package.',
      'date': DateTime.now().subtract(const Duration(days: 2)),
    },
  ];

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
              child: ListView.builder(
                itemCount: historyItems.length,
                itemBuilder: (context, index) {
                  final item = historyItems[index];
                  return HistoryItemCard(
                    title: item['title'],
                    content: item['content'],
                    date: item['date'],
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
