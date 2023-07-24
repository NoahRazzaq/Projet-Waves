import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:project_waves/home.dart';
import 'package:project_waves/login.dart';
import 'package:project_waves/router/app_router.dart';
import 'package:project_waves/services/app_services.dart';
import 'package:project_waves/src/Auth/Controller/AuthController.dart';
import 'package:project_waves/src/Auth/Views/login_page.dart';
import 'package:project_waves/src/Auth/Views/register_stepper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,);
  final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  runApp(MyApp(sharedPreferences: sharedPreferences));

}



class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.sharedPreferences});
  final SharedPreferences sharedPreferences;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  late AppService appService;
  late AuthController authViewModel;
  late AuthController authService;
  late StreamSubscription<bool> authSubscription;

  @override
  void initState() {
    appService = AppService(widget.sharedPreferences);
    authService = AuthController();
    authSubscription = authService.onAuthStateChange.listen(onAuthStateChange);
    onStartUp();
    super.initState();
  }

  void onStartUp() async {
    await appService.onAppStart();
    // listen for changes in auth state
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        // user is logged out
        appService.loginState = false;
        // navigate to login page
        GoRouter.of(context).go('/login');
      } else {
        // user is logged in
        appService.loginState = true;
      }
    });
  }

  void onAuthStateChange(bool login) {
    appService.loginState = login;
  }

  @override
  void dispose() {
    authSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppService>(create: (_) => appService),
        Provider<AppRouter>(create: (_) => AppRouter(appService)),
        Provider<AuthController>(create: (_) => authViewModel),
      ],
      child: Builder(
        builder: (context) {
          final GoRouter goRouter = Provider.of<AppRouter>(context, listen: true).router;
          return MaterialApp.router(
            title: "Router App",
            routerConfig: goRouter,
          );
        },
      ),
    );
  }
}

