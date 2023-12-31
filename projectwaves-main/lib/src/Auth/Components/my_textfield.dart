
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyTextField extends  StatelessWidget {
  final controller;
  final String hinText;
  final bool obscureText;
  final keyboard;
  final maxLines;
  final maxLength;

  const MyTextField({
      super.key,
      required this.controller,
      required this.hinText,
      required this.obscureText,
      required this.keyboard,
      required this.maxLines,
    this.maxLength
  });


  @override
Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        maxLines: maxLines,
        keyboardType: keyboard ,
        controller: controller,
        obscureText: obscureText,
        maxLength: maxLength,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400)
            ),
            fillColor: Colors.grey.shade200,
            filled: true,
          hintText: hinText,
          hintStyle: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
  }