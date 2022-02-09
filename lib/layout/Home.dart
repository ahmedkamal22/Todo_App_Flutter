import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/modules/archived/archived_screen.dart';
import 'package:todo_app/modules/done/done_screen.dart';
import 'package:todo_app/modules/tasks/task_screen.dart';
import 'package:todo_app/shared/components/components.dart';

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
  List<String> titels = ["Tasks", "Done", "Archived"];
  Database? database;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;
  var titleController = TextEditingController();
  var dateController = TextEditingController();
  var timeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    createDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(titels[current]),
      ),
      body: screens[current],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (isBottomSheetShown) {
            if (formKey.currentState!.validate()) {
              insertToDatabase(
                taskTitle: titleController.text,
                taskDate: dateController.text,
                taskTime: timeController.text,
              ).then((value) {
                Navigator.pop(context);
                isBottomSheetShown = false;
                setState(() {
                  fabIcon = Icons.edit;
                });
              });
            }
          }
          else {
            scaffoldKey.currentState?.showBottomSheet(
              (context) => Container(
                color: Colors.white,
                padding: EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      defaultFormField(
                        keyboard_type: TextInputType.text,
                        controller_type: titleController,
                        label_text: "Task Title",
                        Validate: (value) {
                          if (value!.isEmpty) {
                            return "title mustn't be empty";
                          }
                          return null;
                        },
                        prefix_icon: Icons.title,
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      defaultFormField(
                        keyboard_type: TextInputType.datetime,
                        controller_type: dateController,
                        label_text: "Task Date",
                        Validate: (value) {
                          if (value!.isEmpty) {
                            return "date mustn't be empty";
                          }
                          return null;
                        },
                        prefix_icon: Icons.calendar_today,
                        onTap: () {
                          showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.parse("2022-06-18"))
                              .then((value) => dateController.text =
                                  DateFormat.yMMMd().format(value!));
                        },
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      defaultFormField(
                        keyboard_type: TextInputType.datetime,
                        controller_type: timeController,
                        label_text: "Task Time",
                        Validate: (value) {
                          if (value!.isEmpty) {
                            return "time mustn't be empty";
                          }
                          return null;
                        },
                        prefix_icon: Icons.watch_later,
                        onTap: () {
                          showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now())
                              .then((value) =>
                                  timeController.text = value!.format(context));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              elevation: 20.0,
            ).closed.then((value) {
              isBottomSheetShown = false;
              setState(() {
                fabIcon = Icons.edit;
              });
            } );
            isBottomSheetShown = true;
            setState(() {
              fabIcon = Icons.add;
            });
          }
        },
        child: Icon(fabIcon),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: current,
        onTap: (index) {
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

  void createDatabase() async {
    database = await openDatabase("todo.db", version: 1,
        onCreate: (database, version) async {
      print("Database created successfully");
      try {
        await database.execute(
            "CREATE TABLE tasks(id INTEGER PRIMARY KEY,title TEXT,date TEXT,status TEXT,time TEXT)");
        print("table created successfully");
      } catch (error) {
        print("error in database creating: ${error.toString()}");
      }
    }, onOpen: (database) {
      print("database openend");
    });
  }

  Future insertToDatabase(
      {@required String? taskTitle,
      @required String? taskDate,
      @required String? taskTime}) async {
    await database?.transaction((txn) {
      txn
          .rawInsert(
              'INSERT INTO tasks(title,date,status,time) VALUES("$taskTitle","$taskDate","new","$taskTime")')
          .then((value) {
        print("$value inserted successfully");
      }).catchError((error) {
        print("error in database Inserting: ${error.toString()}");
      });
      return null;
    });
  }

  Future<String> getName() async {
    return "Ahmed Kamal";
  }
}
