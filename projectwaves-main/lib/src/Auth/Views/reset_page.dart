import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project_waves/font_sizes.dart';
import 'package:project_waves/src/Auth/Components/button.dart';
import 'package:project_waves/src/Auth/Components/my_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Controller/AuthController.dart';

class ResetPage extends StatelessWidget {
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AuthController authViewModel = AuthController();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 100),
                Container(
                  width: 100,
                  height: 100,
                  child: Image.asset('lib/assets/images/logo-blossom.png'),
                ),
                SizedBox(height: 40),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Enter the email address associated with your Blossom account",
                    style: TextStyle(
                      fontSize: FontSizes.md,
                      fontFamily: 'Inter',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 50),
                MyTextField(
                  maxLines: 1,
                  keyboard: TextInputType.visiblePassword,
                  controller: emailController,
                  hinText: 'example@gmail.com',
                  obscureText: false,
                ),
                SizedBox(height: 10),
                MyButton(
                  text: "Reset Password",
                  onTap: () => authViewModel.passwordReset(emailController.text),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
