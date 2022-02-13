import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/modules/archived/archived_screen.dart';
import 'package:todo_app/modules/done/done_screen.dart';
import 'package:todo_app/modules/tasks/task_screen.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/components/constants.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';

class Home extends StatelessWidget {

  Database? database;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;
  var titleController = TextEditingController();
  var dateController = TextEditingController();
  var timeController = TextEditingController();

  // @override
  // void initState() {
  //   super.initState();

  //   createDatabase();
  // }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:(BuildContext context) => AppCubit() ,
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (context,state){},
        builder: (context,state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            title: Text(cubit.titels[cubit.current]),
          ),
          body: ConditionalBuilder(
            builder: (context) => cubit.screens[cubit.current],
            condition: true,
            fallback: (context) => Center(child: CircularProgressIndicator(
              color: Colors.red,
            )),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (isBottomSheetShown) {
                if (formKey.currentState!.validate()) {
                  insertToDatabase(
                    taskTitle: titleController.text,
                    taskDate: dateController.text,
                    taskTime: timeController.text,
                  ).then((value) {
                    getDataFromDatabase(database).then((value) {
                      Navigator.pop(context);
                      // setState(() {
                      //   isBottomSheetShown = false;
                      //   fabIcon = Icons.edit;
                      //   tasks = value;
                      // });
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
                  // setState(() {
                  //   fabIcon = Icons.edit;
                  // });
                } );
                isBottomSheetShown = true;
                // setState(() {
                //   fabIcon = Icons.add;
                // });
              }
            },
            child: Icon(fabIcon),
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: cubit.current,
            onTap: (index) {
              cubit.changeIndex(index);
              // setState(() {
              //   current = index;
              // });
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
        );},
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
          getDataFromDatabase(database).then((value) {
            // setState(() {
            //   tasks = value;
            // });
          });
          print("database openend");
        });
  }

  Future insertToDatabase(
      {@required String? taskTitle,
        @required String? taskDate,
        @required String? taskTime}) async {
    return await database?.transaction((txn) {
      txn
          .rawInsert(
          'INSERT INTO tasks(title,date,status,time) VALUES("$taskTitle","$taskDate","new","$taskTime")')
          .then((value) {
        print("$value inserted successfully");
      }).catchError((error) {
        print("error in database Inserting: ${error.toString()}");
      });
    throw("");
    });
  }
  Future<List<Map>> getDataFromDatabase(database) async
  {
    return await database!.rawQuery("SELECT * FROM tasks");
  }
  Future<String> getName() async {
    return "Ahmed Kamal";
  }
}

