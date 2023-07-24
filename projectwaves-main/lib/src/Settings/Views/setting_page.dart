
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_waves/services/app_services.dart';
import 'package:project_waves/src/Settings/Views/edit_profile_page.dart';
import 'package:project_waves/src/Settings/Views/help_and_support_page.dart';
import 'package:project_waves/src/Settings/Views/privacy_page.dart';
import 'package:provider/provider.dart';

import '../../Auth/Controller/AuthController.dart';
import '../../Auth/Views/login_page.dart';

class SettingPage extends StatelessWidget {

  String userId = FirebaseAuth.instance.currentUser!.uid;


  @override
  Widget build(BuildContext context) {
    AuthController authViewModel = AuthController();
    final appService = context.watch<AppService>();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Settings',
          style: TextStyle(
            color: Colors.black, // Couleur du texte du titre
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.purple),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),

      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        children: [
          ListTile(
            leading: Icon(Icons.person, color: Colors.purple),
            title: Text('Edit Profile'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfilePage(
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.lock, color: Colors.purple),
            title: Text('Privacy'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PrivacyPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.help, color: Colors.purple),
            title: Text('Help & Support'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HelpAndSupportPage(),
                ),
              );
            },

          ),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.purple),
            title: Text('Logout'),
            onTap: () => authViewModel.logout(() {
              appService.loginState = false;
            }),
          ),
          ListTile(
            leading: Icon(Icons.delete_forever, color: Colors.purple),
            title: Text("Delete account"),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Confirmation"),
                    content: Text("Are you sure you want to delete your account?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("Cancel"),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          await authViewModel.deleteUser(userId);
                          await Future.delayed(Duration(milliseconds: 300));

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ),
                          );

                        },
                        child: Text("Delete"),
                      ),


                    ],
                  );
                },
              );
            },
          )

        ],
      ),
    );
  }
}
