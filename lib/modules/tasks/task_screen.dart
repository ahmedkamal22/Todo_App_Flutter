import 'package:flutter/material.dart';

class Tasks extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Tasks",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 50,
          color: Colors.red
        ),
      ),
    );
  }
}
