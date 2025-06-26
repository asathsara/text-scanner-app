import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryItemCard extends StatelessWidget {
  final String title;
  final String content;
  final DateTime date;

  const HistoryItemCard({
    super.key,
    required this.title,
    required this.content,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Title at the top
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),

          // 2. Content next
          Text(
            content.trim().split('\n').take(2).join('\n'),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 12), // Space between content and date

          // 3. Date last, aligned to the right
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              DateFormat.yMMMd().add_jm().format(date),
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }
}
