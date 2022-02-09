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