import 'package:flutter/material.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/components/constants.dart';

class Tasks extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ListView.separated(itemBuilder: (context,index) => buildTaskItem(tasks[index]),
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
  }
}
