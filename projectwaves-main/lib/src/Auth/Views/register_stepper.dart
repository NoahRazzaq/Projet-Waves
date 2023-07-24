import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_waves/colors.dart';
import 'package:project_waves/src/Auth/Views/login_page.dart';
import 'package:project_waves/src/Auth/Views/reset_page.dart';
import 'package:project_waves/font_sizes.dart';

import '../Components/button.dart';
import '../Components/my_textfield.dart';
import '../Controller/AuthController.dart';

class StepperPage extends StatefulWidget {
  const StepperPage({super.key});
  @override
  _StepperPageState createState() => _StepperPageState();
}

class _StepperPageState extends State<StepperPage> {
  int _activeStepIndex = 0;
  final fullNameController = new TextEditingController();
  final emailController = new TextEditingController();
  final userNameController = new TextEditingController();
  final passwordController = new TextEditingController();
  final confirmPasswordController = new TextEditingController();
  final bioController = new TextEditingController();

  bool isSignedIn = false;

  File? profilePicture;

  String? _validateDescription(String value) {
    if (value.isEmpty) {
      return 'Description is required';
    } else if (value.length > 140) {
      return 'Description must be less than 140 characters';
    }
    return null;
  }



  Future<void> _pickProfilePicture() async {
    final pickedImage =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        profilePicture = File(pickedImage.path);
      });
    }
  }


  Widget _buildProfilePicture() {
    if (profilePicture == null) {
      return ElevatedButton(
        onPressed: _pickProfilePicture,
        child: Text('Select Profile Picture'),
      );
    } else {
      return Column(
        children: [
          Image.file(File(profilePicture!.path)),
          ElevatedButton(
            onPressed: _pickProfilePicture,
            child: Text('Change Profile Picture'),
          ),
        ],
      );
    }
  }



  List<Step> stepList() => [

    Step(
        state:
            _activeStepIndex <= 0 ? StepState.editing : StepState.complete,
        isActive: _activeStepIndex >= 0,
        title: Container(width: 0),
        content: Container(
          child: Column(
            children: [
              const SizedBox(height: 15),
              Text(
                'Add your username',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  color: AppColors.darkBlue,
                  fontSize: FontSizes.xxl,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                'You can modify later',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  color: AppColors.darkBlue,
                  fontSize: FontSizes.sm,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const SizedBox(height: 30),
              MyTextField(
                maxLines: 1,
                keyboard: TextInputType.text,
                controller: userNameController,
                hinText: 'username',
                obscureText: false,
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: RichText(
                  text: TextSpan(
                    text: "Already on Blossom ? ",
                    style: TextStyle(
                      color: AppColors.darkBlue,

                      fontSize: FontSizes.md,
                    ),
                    children: [
                      TextSpan(
                        text: "Sign in",
                        style: TextStyle(
                          color: Colors.purple,
                          fontSize: FontSizes.md,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        )),

    Step(
      state: _activeStepIndex <= 1 ? StepState.editing : StepState.complete,
      isActive: _activeStepIndex >= 1,
      title: Container(width: 0),
      content: Container(
        child: Column(
          children: [
            const SizedBox(height: 15),
            Text(
              'Add your profile picture',
              style: TextStyle(
                fontFamily: 'Outfit',
                color: AppColors.darkBlue,
                fontSize: FontSizes.xxl,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            _buildProfilePicture(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    ),

    Step(
        state:
        _activeStepIndex <= 2 ? StepState.editing : StepState.complete,
        isActive: _activeStepIndex >= 2,
        title: Container(width: 0),
        content: Container(
          child: Column(
            children: [
              const SizedBox(height: 15),
              const Text(
                'Add your name',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  color: Color(0xFF000949),
                  fontSize: FontSizes.xxl,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              MyTextField(
                maxLines: 1,
                keyboard: TextInputType.text,
                controller: fullNameController,
                hinText: 'fullname',
                obscureText: false,
              ),
              const SizedBox(height: 30),
            ],
          ),
        )),

    Step(
        state:
        _activeStepIndex <= 3 ? StepState.editing : StepState.complete,
        isActive: _activeStepIndex >= 3,
        title: Container(width: 0),
        content: Container(
          child: Column(
            children: [
              const SizedBox(height: 15),
              const Text(
                'Add your Bio',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  color: Color(0xFF000949),
                  fontSize: FontSizes.xxl,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              MyTextField(
                  maxLines: 5,
                  controller: bioController,
                  hinText: 'Biographie',
                  obscureText: false,
                  maxLength: 140,
                  keyboard: TextInputType.text
              ),
              const SizedBox(height: 30),
            ],
          ),
        )),

    Step(
        state:
            _activeStepIndex <= 4 ? StepState.editing : StepState.complete,
        isActive: _activeStepIndex >= 4,
        title: Container(width: 0),
        content: Container(
          child: Column(
            children: [
              const SizedBox(height: 15),
              Text(
              'Add your e-mail adress',
              style: TextStyle(
                fontFamily: 'Inter', // Set the font family to Inter
                fontSize: FontSizes.xxl,
                color: AppColors.darkBlue,
                fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              MyTextField(
                maxLines: 1,
                keyboard: TextInputType.emailAddress,
                controller: emailController,
                hinText: 'example@gmail.com',
                obscureText: false,
              ),
              const SizedBox(height: 30),
            ],
          ),
        )),

    Step(
        state:
            _activeStepIndex <= 5 ? StepState.editing : StepState.complete,
        isActive: _activeStepIndex >= 5,
        title: Container(width: 0),
        content: Container(
          child: Column(
            children: [
              const SizedBox(height: 15),
              const Text(
              'Add your password',
                style: TextStyle(
                fontFamily: 'Outfit',
                color: Color(0xFF000949),
                fontSize: FontSizes.xxl,
                fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.0),
                child: Text(
                  'For security reasons, your password must be 6 characters or more.',
              style: TextStyle(
                color: Color(0xFF000949),
                fontSize: FontSizes.sm,
                ), textAlign: TextAlign.center,
              ),
        ),
              const SizedBox(height: 30),
              MyTextField(
                maxLines: 1,
                keyboard: TextInputType.visiblePassword,
                controller: passwordController,
                hinText: 'Password',
                obscureText: true,
              ),
              const SizedBox(height: 15),
              MyTextField(
                maxLines: 1,
                keyboard: TextInputType.visiblePassword,
                controller: confirmPasswordController,
                hinText: 'Confirm password',
                obscureText: true,
              ),
            ],
          ),
        )),

      ];

  @override
  Widget build(BuildContext context) {
    AuthController authViewModel = AuthController();

    return Scaffold(
        body: Container(
          padding: EdgeInsetsDirectional.only(top: 30),
          child:Theme(
            data: ThemeData(
                colorScheme: ColorScheme.light(primary: AppColors.purple)),
            child: Stepper(
              margin: EdgeInsetsDirectional.only(top: 30),
              controlsBuilder:
                  (BuildContext context, ControlsDetails details) {
                return Container(
                  margin: EdgeInsets.only(top: 15),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          TextButton(
                            onPressed: details.onStepCancel,
                            child: Text(
                              'Back',
                              style:
                                TextStyle(fontSize: FontSizes.xl),
                            ),
                          ),
                          const SizedBox(width: 30),
                          ElevatedButton(
                            onPressed: details.onStepContinue,
                            style: ElevatedButton.styleFrom(
                              primary: AppColors.purple, // Couleur violette
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 8
                              ),
                            ),

                            child: Text(
                              'Continue',
                              style: TextStyle(fontSize: FontSizes.xl),
                            ),
                          ),

                        ],
                      ),
                    ],
                  ),
                );
              },
              type: StepperType.horizontal,
              elevation: .5,
              currentStep: _activeStepIndex,
              steps: stepList(),
              onStepContinue: () {
                if (_activeStepIndex < (stepList().length - 1)) {
                  _activeStepIndex += 1;
                }
                authViewModel.signUserUp(
                    emailController.text,
                    passwordController.text,
                    confirmPasswordController.text,
                    userNameController.text,
                   fullNameController.text,
                    bioController.text,
                  profilePicture
                    );

                setState(() {});
              },
              onStepCancel: () {
                if (_activeStepIndex == 0) {
                  return;
                }
                _activeStepIndex -= 1;
                setState(() {});
              },
            ),
          )
        ),
      );
  }
}
