import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/components/constants.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';

class Archived extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){},
      builder: (context,state) {
        var tasks = AppCubit.get(context).archivedTasks;
        return ListView.separated(itemBuilder: (context,index) => buildTaskItem(tasks[index],context),
            separatorBuilder: (context,index) => Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Container(
                width: double.infinity,
                height: 1,
                color: Colors.blue[200],
              ),
            ),
            itemCount: tasks.length);
      },
    );
  }
}
