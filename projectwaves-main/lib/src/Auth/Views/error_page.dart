
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project_waves/src/Auth/Components/button.dart';
import 'package:project_waves/src/Auth/Components/my_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Controller/AuthController.dart';


class ErrorPage extends StatelessWidget {
  final emailController = new TextEditingController();


  @override
  Widget build(BuildContext context) {
    AuthController authViewModel = AuthController();
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 200),
              MyTextField(
                maxLines: 1,
                keyboard: TextInputType.text,
                controller: emailController,
                hinText: 'Username',
                obscureText: false,
              ),
              const SizedBox(height: 10),
              MyButton(text: "Reset Password",
                  onTap: () => authViewModel.passwordReset(emailController.text)),

            ],
          ),
        ),
      ),
    );
  }


}