import 'package:flutter/material.dart';

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
Widget buildTaskItem(Map task) => Padding(
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
      Column(
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
    ],
  ),
);