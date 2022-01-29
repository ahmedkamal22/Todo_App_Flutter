import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:todo_app/modules/archived/archived_screen.dart';
import 'package:todo_app/modules/done/done_screen.dart';
import 'package:todo_app/modules/tasks/task_screen.dart';

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int current = 0;
  List<Widget> screens = [
    Tasks(),
    Done(),
    Archived(),
  ];
  List<String> titels = [
    "Tasks",
    "Done",
    "Archived"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            titels[current]
        ),
      ),
      body: screens[current],
      floatingActionButton: FloatingActionButton(
        onPressed: () async
        {
          try
          {
            var name = await getName();
            print(name);
            print("adsasasdasd");
            throw("error here");
          }catch(error)
          {
            print("error in(${error.toString()})");
          };
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: current,
        onTap: (index){
          setState(() {
            current = index;
          });
        },
        backgroundColor: Colors.grey[200],
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: "Tasks",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_outline),
            label: "Done",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.archive_outlined),
            label: "Archived",
          ),
        ],
      ),
    );
  }

  Future<String> getName() async
  {
    return "Ahmed Kamal";
  }
}
