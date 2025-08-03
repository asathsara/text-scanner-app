import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:text_extractor_app/utils/constants/colors.dart';

class ImageUploadCard extends StatelessWidget {
  final XFile? imageFile;
  final VoidCallback onTap;

  const ImageUploadCard({
    super.key,
    required this.imageFile,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? Colors.grey[900] : Colors.grey[100];
    final iconColor = isDark ? Colors.blueGrey[200] : MyColors.iconGray;
    final textColor = isDark ? Colors.blueGrey[100] : MyColors.iconGray;

    return Card(
      elevation: 2,
      shadowColor: isDark ? Colors.grey[900]: Colors.grey.withValues(alpha: 0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: cardColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          height: 180,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: cardColor,
          ),
          child: imageFile != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.file(File(imageFile!.path), fit: BoxFit.cover),
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_photo_alternate_rounded,
                        size: 48,
                        color: iconColor,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Tap to upload image",
                        style: TextStyle(color: textColor, fontSize: 16),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
