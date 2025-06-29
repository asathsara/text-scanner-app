import 'package:flutter/material.dart';
import 'package:text_extractor_app/screens/history_screen.dart';
import 'package:text_extractor_app/screens/image_text_screen.dart';
import 'package:text_extractor_app/screens/text_editor_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Navigate to specific page
  void navigateToPage(int page) {
    if (page >= 0 && page < 3) {
      setState(() {
        _currentPage = page;
      });
      _pageController.jumpToPage(page);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [ImageTextScreen(), HistoryScreen(), TextEditorScreen()],
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (index) => navigateToPage(index),
        selectedIndex: _currentPage,
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.image),
            label: 'Image to Text',
          ),
          NavigationDestination(icon: Icon(Icons.history), label: 'History'),
          NavigationDestination(icon: Icon(Icons.edit), label: 'Text Editor'),
        ],
      ),
    );
  }
}
