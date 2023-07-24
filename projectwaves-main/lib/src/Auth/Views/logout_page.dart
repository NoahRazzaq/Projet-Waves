import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project_waves/home.dart';
import 'package:project_waves/services/app_services.dart';
import 'package:project_waves/src/Auth/Components/button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Controller/AuthController.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthController authViewModel = AuthController();
    final appService = context.watch<AppService>();

    return MyButton(
      text: "Logout",
      onTap: () => authViewModel.logout(() {
        appService.loginState = false;
      }),
    );
  }
}
