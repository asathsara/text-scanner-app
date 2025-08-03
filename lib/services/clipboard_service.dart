import 'package:flutter/services.dart';

class ClipboardService {
  static Future<void> copy(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
  }

  static Future<String?> paste() async {
    final data = await Clipboard.getData('text/plain');
    return data?.text;
  }
}
