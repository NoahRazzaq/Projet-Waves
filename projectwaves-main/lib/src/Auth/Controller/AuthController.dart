import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:project_waves/home.dart';
import 'package:project_waves/login.dart';
import 'package:project_waves/src/Auth/Views/login_page.dart';
import 'package:project_waves/src/Auth/Views/register_stepper.dart';
import 'package:project_waves/src/Models/UserModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_waves/font_sizes.dart';

import '../Utils/database.dart';

class AuthController {

  final StreamController<bool> _onAuthStateChange =
      StreamController.broadcast();
  Stream<bool> get onAuthStateChange => _onAuthStateChange.stream;

  Future<bool> signUserIn(email, password, Function onComplete) async {
    try {
      final user = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      Fluttertoast.showToast(
          msg: "Account connected",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: FontSizes.md);
      // lets save user with shared prefrences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("userID", user.user!.uid);
      print(user.user!.uid);
      DatabaseAuthMethods().setCurrentUser();
      onComplete();
      return true;
    } on FirebaseException catch (e) {
      if (e.code == 'user-not-found') {
        Fluttertoast.showToast(
            msg: "Incorrect e-mail or password. Try again",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: FontSizes.md);
      } else if (e.code == 'wrong-password') {
        Fluttertoast.showToast(
            msg: "Incorrect e-mail or password. Try again",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.redAccent,
            textColor: Colors.white,
            fontSize: FontSizes.md);
      }
      return false;
    }
  }

  void signUserUp(email, password, confirmPassword, username, fullname, bio, profilePicture) async {
    if (password != confirmPassword) {
      Fluttertoast.showToast(
          msg: "Passwords do not match",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: FontSizes.md);
      return; // Return early if passwords don't match
    }

    if (!RegExp(r'^[a-z]+$').hasMatch(username)) {
      Fluttertoast.showToast(
          msg: "Username should be in lowercase",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: FontSizes.md);
      return;
    }

    bool usernameExists = await checkUsernameExists(username);
    if (usernameExists) {
      Fluttertoast.showToast(
          msg: "Username already exists",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: FontSizes.md);
      return; // Return early if username exists
    }

    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);


      if (profilePicture != null) {
        String fileName = path.basename(profilePicture!.path);
        firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref().child('profilePictures/$fileName');

        await ref.putFile(profilePicture!);
        String imageUrl = await ref.getDownloadURL();

        profilePicture = imageUrl;
      } else {
        profilePicture = "";
      }

      UserModel account = UserModel(email: email, username: username, fullname: fullname, bio: bio, profilePicture: profilePicture);

      if (UserCredential != null) {
        DatabaseAuthMethods().addUserInfoToDB(
            FirebaseAuth.instance.currentUser!.uid, account.toJson());
      }
      Fluttertoast.showToast(
          msg: "Account created",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.lightGreen,
          textColor: Colors.white,
          fontSize: FontSizes.md);
      DatabaseAuthMethods().setCurrentUser();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Fluttertoast.showToast(
            msg: "Your password is weak",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: FontSizes.md);
      } else if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(
            msg: "Email adress already exists",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: FontSizes.md);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Erreur: $e');
    }
  }

  void passwordReset(email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      Fluttertoast.showToast(
          msg: "Password reset link sent ! ",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: FontSizes.md);
    } on FirebaseException catch (e) {
      Fluttertoast.showToast(
          msg: "Email does not exist. Check your email adress",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          fontSize: FontSizes.md);
    }
  }

  Future<bool> checkUsernameExists(String username) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .get();
    return snapshot.docs.isNotEmpty;
  }

  void logout(Function onComplete) async {
    await FirebaseAuth.instance.signOut();
    onComplete();
  }

  void updateUsername(String newUsername) {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance.collection('users').doc(userId).update({
      'username': newUsername,
    }).then((value) {
      Fluttertoast.showToast(
          msg: 'Username updated successfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    }).catchError((error) {
      Fluttertoast.showToast(
          msg: 'Failed to update username: $error',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    });
  }

  void updateFullName(String newFullName) {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance.collection('users').doc(userId).update({
      'fullname': newFullName,
    }).then((value) {
      Fluttertoast.showToast(
          msg: 'Full name updated successfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    }).catchError((error) {
      Fluttertoast.showToast(
          msg: 'Failed to update full name: $error',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    });
  }

  void updateBio(String newBio) {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance.collection('users').doc(userId).update({
      'bio': newBio,
    }).then((value) {
      Fluttertoast.showToast(
          msg: 'Biography updated successfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    }).catchError((error) {
      Fluttertoast.showToast(
          msg: 'Failed to update biography: $error',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    });
  }

  void updateEmail(String newEmail) {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance.collection('users').doc(userId).update({
      'email': newEmail,
    }).then((value) {
      Fluttertoast.showToast(
          msg: 'email updated successfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    }).catchError((error) {
      Fluttertoast.showToast(
          msg: 'Failed to update email: $error',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    });
  }


  Future<void> deleteUser(String userId) async {
    try {
      // Step 1: Delete the user document from the 'users' collection
      await FirebaseFirestore.instance.collection('users').doc(userId).delete();

      // Step 2: Remove user ID reference from the 'posts' collection
      QuerySnapshot postSnapshot = await FirebaseFirestore.instance
          .collection('post')
          .where('uid', isEqualTo: userId)
          .get();

      List<Future<void>> deletePostTasks = [];
      postSnapshot.docs.forEach((postDoc) {
        deletePostTasks.add(postDoc.reference.delete());
      });

      await Future.wait(deletePostTasks);

      // Step 3: Remove user ID reference from the 'events' collection
      QuerySnapshot eventSnapshot = await FirebaseFirestore.instance
          .collection('events')
          .where('uid', isEqualTo: userId)
          .get();

      List<Future<void>> deleteEventTasks = [];
      eventSnapshot.docs.forEach((eventDoc) {
        deleteEventTasks.add(eventDoc.reference.delete());
      });

      await Future.wait(deleteEventTasks);

      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.delete();
      }

      print('User deleted successfully.');
    } catch (e) {
      print('Failed to delete user: $e');
    }
  }


}
