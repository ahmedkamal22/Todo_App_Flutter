import 'package:flutter/material.dart';

class Done extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Done",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 50,
          color: Colors.red
        ),
      ),
    );
  }
}
