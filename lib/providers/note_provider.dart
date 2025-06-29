import 'package:flutter/material.dart';

class NoteProvider extends ChangeNotifier {
  String _title = '';
  String _content = '';

  String get title => _title;
  String get content => _content;

  void setNote(String title, String content) {
    _title = title;
    _content = content;
    notifyListeners();
  }

  void clearNote() {
    _title = '';
    _content = '';
    notifyListeners();
  }
}
