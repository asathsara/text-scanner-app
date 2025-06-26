import 'package:flutter/material.dart';
import 'package:text_extractor_app/utils/constants/colors.dart';

class NoteActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const NoteActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: isDark ? MyColors.white : MyColors.mediumGray),
          const SizedBox(height: 4),
          Text(
            label,
            style:  TextStyle(color: isDark ? MyColors.white : MyColors.mediumGray),
          ),
        ],
      ),
    );
  }
}
