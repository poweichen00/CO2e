import 'package:flutter/material.dart';
import 'action_view.dart';

class ViewTile extends StatelessWidget {
  final ActionView actionview;
  void Function()? onPressed;
  ViewTile({super.key, required  this.actionview, required this.onPressed,});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200], borderRadius: BorderRadius.circular(12)
      ),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: ListTile(
        title: Text(actionview.name),
        leading: Image.asset(actionview.imagePath),
        trailing: IconButton(
          icon: Icon(Icons.view_list_sharp),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
