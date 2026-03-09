import 'package:flutter/material.dart';

class DashBoardScreen extends StatelessWidget {
  const DashBoardScreen({super.key});
  static const String id="dashbosrd";

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          "Welcome Admin!"
        ),
      ),
    );
  }
}
