import 'package:flutter/material.dart';

class Archived extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Archived",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 50,
          color: Colors.red
        ),
      ),
    );
  }
}
