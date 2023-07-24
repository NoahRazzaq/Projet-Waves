import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../../Auth/Controller/AuthController.dart';


class EditProfilePage extends StatelessWidget {
  final username = TextEditingController();
  final fullName = TextEditingController();
  final biography = TextEditingController();
  final email = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  File? _profilePicture;

  final AuthController authViewModel = AuthController();

  Future<void> updateProfilePicture(File newProfilePicture) async {
    // Upload image to Firebase Storage
    final firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('profile_pictures')
        .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

    try {
      await ref.putFile(newProfilePicture);
      final imageUrl = await ref.getDownloadURL();

      // Update the profile picture field in the Firestore collection
      String userId = FirebaseAuth.instance.currentUser!.uid;
      FirebaseFirestore.instance.collection('users').doc(userId).update({
        'profilePicture': imageUrl,
      });

      Fluttertoast.showToast(
        msg: 'Profile picture updated successfully',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } catch (error) {
      Fluttertoast.showToast(
        msg: 'Failed to update profile picture: $error',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  Future<void> _selectImage(BuildContext context) async {
    final pickedFile = await _imagePicker.getImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      File selectedImage = File(pickedFile.path);
      updateProfilePicture(selectedImage);
    }
  }

  void _showAlertDialog(BuildContext context, Widget content, List<Widget> actions) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        if (Platform.isAndroid) {
          return AlertDialog(
            content: content,
            actions: actions,
          );
        } else if (Platform.isIOS) {
          return CupertinoAlertDialog(
            content: content,
            actions: actions,
          );
        }
        return SizedBox.shrink();
      },
    );
  }

  void _editUsername(BuildContext context) {
    final content = TextField(
      decoration: InputDecoration(
        labelText: 'Username',
      ),
      controller: username,
    );

    final actions = [
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text('Cancel'),
      ),
      ElevatedButton(
        onPressed: () async {
          bool usernameExists = await authViewModel.checkUsernameExists(username.text);

          if (usernameExists) {
            Fluttertoast.showToast(
              msg: 'Username already exists',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0,
            );
          } else {
            authViewModel.updateUsername(username.text); // Update the username
            Navigator.of(context).pop(); // Close the dialog
          }
        },
        child: Text('Save'),
      ),
    ];

    _showAlertDialog(context, content, actions);
  }

  void _editFullName(BuildContext context) {
    final content = TextField(
      decoration: InputDecoration(
        labelText: 'Full Name',
      ),
      controller: fullName,
    );

    final actions = [
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text('Cancel'),
      ),
      ElevatedButton(
        onPressed: () {
          authViewModel.updateFullName(fullName.text);
          Navigator.of(context).pop();
        },
        child: Text('Save'),
      ),
    ];

    _showAlertDialog(context, content, actions);
  }

  void _editBiography(BuildContext context) {
    final content = TextField(
      decoration: InputDecoration(
        labelText: 'Biography',
      ),
      controller: biography,
    );

    final actions = [
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text('Cancel'),
      ),
      ElevatedButton(
        onPressed: () {
          authViewModel.updateBio(biography.text);
          Navigator.of(context).pop();
        },
        child: Text('Save'),
      ),
    ];

    _showAlertDialog(context, content, actions);
  }

  void _editEmail(BuildContext context) {
    final content = TextField(
      decoration: InputDecoration(
        labelText: 'Email',
      ),
      controller: email,
    );

    final actions = [
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text('Cancel'),
      ),
      ElevatedButton(
        onPressed: () {
          authViewModel.updateEmail(email.text);
          Navigator.of(context).pop();
        },
        child: Text('Save'),
      ),
    ];

    _showAlertDialog(context, content, actions);
  }

  void _editAvatar(BuildContext context) {
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          backgroundImage: _profilePicture != null ? FileImage(_profilePicture!) : null,
          child: _profilePicture == null ? Icon(Icons.person, size: 48, color: Colors.white) : null,
          radius: 48,
        ),
        SizedBox(height: 16.0),
        ElevatedButton(
          onPressed: () => _selectImage(context),
          child: Text('Select Image'),
        ),
        SizedBox(height: 8.0),
      ],
    );

    final actions = [
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text('Cancel'),
      ),
    ];

    _showAlertDialog(context, content, actions);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Edit Profile',
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
            title: Text('Edit Username'),
            onTap: () {
              _editUsername(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.person, color: Colors.purple),
            title: Text('Edit Full Name'),
            onTap: () {
              _editFullName(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.description, color: Colors.purple),
            title: Text('Edit Biography'),
            onTap: () {
              _editBiography(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.email, color: Colors.purple),
            title: Text('Edit Email'),
            onTap: () {
              _editEmail(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.image, color: Colors.purple),
            title: Text('Edit Avatar'),
            onTap: () {
              _editAvatar(context);
            },
          ),
        ],
      ),
    );
  }
}
