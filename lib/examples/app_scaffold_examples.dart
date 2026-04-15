import 'package:flutter/material.dart';
import '../shared/widgets/app_scaffold.dart';

/// Contoh penggunaan AppScaffold untuk berbagai kasus
class AppScaffoldExamples {
  /// 1. Basic page dengan scrolling
  static Widget basicPage() {
    return const AppScaffold(
      child: Column(
        children: [
          Text('Basic Page Content'),
          SizedBox(height: 1000), // Force scrolling
          Text('Bottom Content'),
        ],
      ),
    );
  }

  /// 2. Page dengan AppBar dan BottomNavigationBar
  static Widget pageWithAppBarAndBottomNav() {
    return AppScaffold(
      appBar: AppBar(
        title: const Text('Page Title'),
        backgroundColor: const Color(0xFFE74C3C),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        ],
      ),
      child: const Center(
        child: Text('Content with AppBar and BottomNav'),
      ),
    );
  }

  /// 3. Page tanpa scrolling (untuk forms atau fixed layout)
  static Widget fixedLayoutPage() {
    return const AppScaffold(
      enableScrolling: false,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text('Fixed Layout Page'),
            Spacer(),
            Text('Always at bottom'),
          ],
        ),
      ),
    );
  }

  /// 4. Page dengan custom padding
  static Widget pageWithCustomPadding() {
    return const AppScaffold(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Text('Content with custom padding'),
    );
  }

  /// 5. Page dengan custom background color
  static Widget pageWithCustomBackground() {
    return const AppScaffold(
      backgroundColor: Colors.lightBlue,
      child: Center(
        child: Text(
          'Custom Background',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  /// 6. Page tanpa SafeArea (untuk full screen content)
  static Widget fullScreenPage() {
    return const AppScaffold(
      safeArea: false,
      backgroundColor: Colors.black,
      child: Center(
        child: Text(
          'Full Screen Content',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  /// 7. Page dengan FloatingActionButton
  static Widget pageWithFAB() {
    return AppScaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFFE74C3C),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      child: const Center(
        child: Text('Page with Floating Action Button'),
      ),
    );
  }
}
