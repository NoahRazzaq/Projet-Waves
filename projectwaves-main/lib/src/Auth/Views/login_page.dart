import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project_waves/home.dart';
import 'package:project_waves/font_sizes.dart';
import 'package:project_waves/services/app_services.dart';
import 'package:project_waves/src/Auth/Components/button.dart';
import 'package:project_waves/src/Auth/Components/my_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_waves/src/Auth/Views/register_stepper.dart';
import 'package:project_waves/src/Auth/Views/reset_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Controller/AuthController.dart';



class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = new TextEditingController();
  final passwordController = new TextEditingController();
  final connected = false;

  @override
  Widget build(BuildContext context) {
    AuthController authViewModel = AuthController();
    final AppService appService =
        Provider.of<AppService>(context, listen: true);

    return Scaffold(
      resizeToAvoidBottomInset: false, // set it to false
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  child: Image.asset('lib/assets/images/logo-blossom.png'),
                ),
                const SizedBox(height: 50),
                MyTextField(
                  maxLines: 1,
                  keyboard: TextInputType.emailAddress,
                  controller: emailController,
                  hinText: 'example@gmail.com',
                  obscureText: false,

                ),
                const SizedBox(height: 10),
                MyTextField(
                  maxLines: 1,
                  keyboard: TextInputType.visiblePassword,
                  controller: passwordController,
                  hinText: 'password',
                  obscureText: true,
                ),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ResetPage()),
                    );
                  },
                  child: RichText(
                    text: TextSpan(
                      text: "Forgot password ? ",
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Inter', // Set the font family to Inter
                        fontSize: FontSizes.sm,
                      ),
                      children: [
                        TextSpan(
                          text: "Click here",
                          style: TextStyle(
                            color: Colors.purple,
                            fontFamily: 'Inter', // Set the font family to Inter
                            fontSize: FontSizes.sm,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                MyButton(
                    text: "Sign in",
                    onTap: () => authViewModel.signUserIn(
                            emailController.text, passwordController.text, () {
                          appService.loginState = true;
                        })),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => StepperPage()),
                    );
                  },
                  child: RichText(
                    text: const TextSpan(
                      text: "Don't have an account ? ",
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Inter',
                        fontSize: FontSizes.sm,
                      ),
                      children: [
                        TextSpan(
                          text: "Sign up",
                          style: TextStyle(
                            color: Colors.purple,
                            fontFamily: 'Inter', // Set the font family to Inter
                            fontSize: FontSizes.sm,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
