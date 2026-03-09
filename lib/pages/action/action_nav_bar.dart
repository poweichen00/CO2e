import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class ActionNavBar extends StatelessWidget {
  void Function(int)? onTabChange;
  ActionNavBar({
    super.key,
    required this.onTabChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(25),
      child: GNav(
          onTabChange: (value) => onTabChange!(value),
          color: Colors.grey[400],
          mainAxisAlignment: MainAxisAlignment.center,
          activeColor: Colors.grey[700],
          tabBackgroundColor: Colors.grey.shade300,
          tabBorderRadius: 24,
          tabActiveBorder: Border.all(color: Colors.white),
          tabs: const [
            GButton(
              icon: Icons.format_list_bulleted_outlined,
              text: ' 行動列表',
            ),
            GButton(
              icon: Icons.task_alt,
              text: ' 你的行動',
            ),
          ]),
    );
  }
}
