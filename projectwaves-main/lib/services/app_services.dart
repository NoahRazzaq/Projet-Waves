// ignore: non_constant_identifier_names
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

String LOGIN_KEY = "5FD6G46SDF4GD64F1VG9SD68";
// ignore: non_constant_identifier_names
String HOME_KEY = "GD2G82CG9G82VDFGVD22DVG";

class AppService with ChangeNotifier {
  late final SharedPreferences sharedPreferences;
  final StreamController<bool> _loginStateChange = StreamController<bool>.broadcast();
  //final StreamController<bool> _registerStateChange = StreamController<bool>.broadcast();

  bool _loginState = false;
  //bool _registerState = false;
  bool _homeState = false;

  AppService(this.sharedPreferences);

  bool get loginState => _loginState;
  //bool get registerState => _registerState;
  bool get home => _homeState;
  Stream<bool> get loginStateChange => _loginStateChange.stream;

  set loginState(bool state) {
    sharedPreferences.setBool(LOGIN_KEY, state);

    print('logState $_loginState');
    _loginState = state;
    _loginStateChange.add(state);
    notifyListeners();
  }


  set home(bool value) {
    sharedPreferences.setBool(HOME_KEY, value);
    home = value;
    notifyListeners();
  }

  Future<void> onAppStart() async {
    _homeState = sharedPreferences.getBool(HOME_KEY) ?? false;
    _loginState = sharedPreferences.getBool(LOGIN_KEY) ?? false;

    print(_loginState);
    // This is just to demonstrate the splash screen is working.
    // In real-life applications, it is not recommended to interrupt the user experience by doing such things.
    await Future.delayed(const Duration(seconds: 2));

    notifyListeners();
  }
}
