import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/modules/archived/archived_screen.dart';
import 'package:todo_app/modules/done/done_screen.dart';
import 'package:todo_app/modules/tasks/task_screen.dart';
import 'package:todo_app/shared/cubit/states.dart';

class AppCubit extends Cubit<AppStates>
{
  AppCubit():super(AppInitialState());
  static AppCubit get(context) => BlocProvider.of(context);
  int current = 0;
  List<Widget> screens = [
    Tasks(),
    Done(),
    Archived(),
  ];
  List<String> titels = ["Tasks", "Done", "Archived"];

  List<Map> tasks = [];

  Database? database;
  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;

  void changeIndex(int index)
  {
    current = index;
    emit(ChangeBottomNavIndexState());
  }
  void changeBottomNavState({
  @required bool? isShown,
  @required IconData? icon,
})
  {
    isBottomSheetShown = isShown!;
    fabIcon = icon!;
    emit(AppChangeBottomNavState());
  }
  void createDatabase() {
    openDatabase("todo.db", version: 1,
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
            tasks = value;
            emit(AppGetDatabaseState());
          });
          print("database openend");
        },).then((value) {
          database = value;
      emit(AppCreateDatabaseState());
    });
  }

  insertToDatabase(
      {@required String? taskTitle,
        @required String? taskDate,
        @required String? taskTime}) async {
    await database?.transaction((txn) {
      txn
          .rawInsert(
          'INSERT INTO tasks(title,date,status,time) VALUES("$taskTitle","$taskDate","new","$taskTime")')
          .then((value) {
        print("$value inserted successfully");
        emit(AppInsertDatabaseState());
        getDataFromDatabase(database).then((value) {
          tasks = value;
          emit(AppGetDatabaseState());
        });
      }).catchError((error) {
        print("error in database Inserting: ${error.toString()}");
      });
      return null;
    });
  }

  Future<List<Map>> getDataFromDatabase(database) async
  {
    emit(AppGetDatabaseLoadingState());
    return await database!.rawQuery("SELECT * FROM tasks");
  }

}