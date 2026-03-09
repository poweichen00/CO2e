import 'package:flutter/material.dart';
import 'package:c_o2e/pages/action/action_nav_bar.dart';
import 'package:c_o2e/pages/action/view/view_page.dart';
import 'action_page.dart';
import 'action_history.dart'; // 导入 HistoryPage

class ActionHome extends StatefulWidget {
  const ActionHome({super.key});

  @override
  State<ActionHome> createState() => _ActionHomeState();
}

class _ActionHomeState extends State<ActionHome> {
  int _selectedIndex = 0;

  void navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    ViewPage(),
    ActionPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HistoryPage(),
                ),
              );
            },
            child: const Text(
              '歷史紀錄',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      bottomNavigationBar: ActionNavBar(
        onTabChange: (index) => navigateBottomBar(index),
      ),
      body: _pages[_selectedIndex],
    );
  }
}
