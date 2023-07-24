import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_waves/src/Models/UserModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseAuthMethods {
  Future addUserInfoToDB(String userId, Map<String, dynamic> userInfoMap) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .set(userInfoMap);
  }

  Future<DocumentSnapshot<Object?>> getUserFromDB(String userId) async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection("users").doc(userId).get();
    return snapshot;
  }

// Get the currently authenticated user ID
  String getCurrentUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      // User is not authenticated
      return '';
    }
  }

  Future<UserModel?> getCurrentUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userData = prefs.getString(("user"));
    UserModel? currentUser;
    if(userData != null){
      currentUser = UserModel.fromJson(jsonDecode(userData));
    } else {
      currentUser = null;
    }

    return currentUser;
  }

  void setCurrentUser() async {

    User? user = FirebaseAuth.instance.currentUser;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DocumentSnapshot snapshot = await DatabaseAuthMethods().getUserFromDB(user!.uid);
    UserModel currentUser = UserModel.fromJson(snapshot.data() as Map<String, dynamic>);

    prefs.setString("user", jsonEncode(currentUser.toJson()));
  }

}