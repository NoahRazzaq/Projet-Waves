import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_waves/colors.dart';

class MyButton extends StatelessWidget {
  final Function ()?  onTap;
  final String text;

  const MyButton ({super.key, required this.onTap, required this.text});

  @override
  Widget build (BuildContext context) {
    return GestureDetector(
        onTap: onTap ,
        child: Container(
          padding: const EdgeInsets.all(25),
          margin: const EdgeInsets.symmetric (horizontal: 25),
          decoration: BoxDecoration(
            color: AppColors.purple,
              borderRadius: BorderRadius.circular (8),
      ), // BoxDecoration
        child: Center(
        child: Text(
         text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ), // TextStyle
       ), // Text
      ), // Center
     ), // Container
    ); // GestureDetector
  }
}