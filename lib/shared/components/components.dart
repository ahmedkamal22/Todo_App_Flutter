import 'package:flutter/material.dart';
import 'package:todo_app/shared/cubit/cubit.dart';

Widget defaultFormField({
  @required TextInputType? keyboard_type,
  @required TextEditingController? controller_type,
  @required String? label_text,
  IconData? prefix_icon,
  IconData? suffix_icon,
  Function(String)? onChange,
  Function(String)? onSubmit,
  VoidCallback? onTap,
  @required String? Function(String?)? Validate,
  VoidCallback? isPasswordVisible,
  bool isVisible = false,
}) => TextFormField(
  keyboardType: keyboard_type,
  controller: controller_type,
  obscureText: isVisible,
  onChanged: onChange,
  onTap: onTap,
  onFieldSubmitted: onSubmit,
  validator: Validate,
  decoration: InputDecoration(
    labelText: label_text,
    prefixIcon: Icon(prefix_icon),
    suffixIcon: suffix_icon!=null ? IconButton(
        onPressed: isPasswordVisible,
        icon: Icon(suffix_icon)):null,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20.0),
    ),
  ),
);
Widget buildTaskItem(Map task,context) => Padding(
  padding: const EdgeInsets.all(20.0),
  child: Row(
    children: [
      CircleAvatar(
        radius: 40,
        child: Text(
          "${task["time"]}",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      SizedBox(width: 15.0,),
      Expanded(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${task["title"]}',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 20.0
              ),
            ),
            SizedBox(height: 7.0,),
            Text(
              '${task["date"]}',
              style: TextStyle(
                  color: Colors.grey
              ),
            ),
          ],
        ),
      ),
      SizedBox(width: 15.0,),
      IconButton(onPressed: (){
        AppCubit.get(context).updateData(
            status: "done", id: task["id"]);
      },
          icon: Icon(
              Icons.check_circle,
              color: Colors.green,
          )),
      IconButton(onPressed: (){
        AppCubit.get(context).updateData(
            status: "archived", id: task["id"]);
      },
          icon: Icon(
            Icons.archive,
            color: Colors.black45,
          )),
    ],
  ),
);