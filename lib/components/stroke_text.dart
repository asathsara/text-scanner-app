import 'package:flutter/material.dart';
import 'package:text_extractor_app/utils/constants/colors.dart';

class StrokeText extends StatelessWidget {
  final String text;
  final Color? strokeColor;
  final Color? fillColor;
  final double fontSize;
  final double strokeWidth;

  const StrokeText({
    super.key,
    required this.text,
    this.strokeColor,
    this.fillColor,
    this.fontSize = 28.0,
    this.strokeWidth = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final effectiveStrokeColor = strokeColor ?? (isDark ? MyColors.backgroundGray : MyColors.textBlue);
    final effectiveFillColor = fillColor ?? (isDark ? MyColors.backgroundGray : MyColors.textBlue);

    return Stack(
      children: [
        // Stroked text (below the main text)
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = strokeWidth
              ..color = effectiveStrokeColor,
          ),
        ),
        // Solid fill text (on top of stroked)
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: effectiveFillColor,
            shadows: [
              Shadow(
                blurRadius: 4.0,
                color: effectiveStrokeColor,
                offset: Offset(0, 0),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
