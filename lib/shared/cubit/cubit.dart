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

  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

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
          getDataFromDatabase(database);
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
        getDataFromDatabase(database);
      }).catchError((error) {
        print("error in database Inserting: ${error.toString()}");
      });
      return null;
    });
  }

  void getDataFromDatabase(database)
  {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    emit(AppGetDatabaseLoadingState());
    database!.rawQuery("SELECT * FROM tasks").then((value) {
      value.forEach((element) {
        if(element['status'] == 'new')
          {
            newTasks.add(element);
          }
        else if(element["status"] == "done")
        {
          doneTasks.add(element);
        }
        else
          archivedTasks.add(element);

      });
      emit(AppGetDatabaseState());
    });
  }

  void updateData({
   @required String? status,
    @required int? id,
}) async
  {
    database!.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id]).then((value) {
          getDataFromDatabase(database);
          emit(AppUpdateState());
    });
  }

  void deleteData({
    @required int? id,
  }) async
  {
    database!.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      getDataFromDatabase(database);
      emit(AppDeleteState());
    });
  }
}