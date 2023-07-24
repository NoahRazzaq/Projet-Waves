import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:project_waves/src/Models/Post.dart';
import 'package:project_waves/main.dart';

import '../../../home.dart';
import '../../Auth/Utils/database.dart';

class PostController {
  Future<String?> uploadImageToFirebase(String imagePath) async {
    String? url;

    String fileName = basename(imagePath);
    File imageFile = File(imagePath);
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child(fileName! + DateTime.now().toString());
    UploadTask uploadTask = ref.putFile(imageFile);

    await uploadTask.whenComplete(() async {
      url = await ref.getDownloadURL();
    }).catchError((onError) {
      print(onError);
    });
    return url;
  }

  Future<String?> uploadImageThumbnailToFirebase(String imagePath) async {
    String? url;

    String fileName = basename(imagePath);
    File compressedFile =
    await FlutterNativeImage.compressImage(imagePath, quality: 50, percentage: 20);
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference refThumbnail =
    storage.ref().child(fileName! + "thumbnail" + DateTime.now().toString());
    UploadTask uploadTaskThumbnail = refThumbnail.putFile(compressedFile);

    await uploadTaskThumbnail.whenComplete(() async {
      url = await refThumbnail.getDownloadURL();
      print(url);
    }).catchError((onError) {
      print(onError);
    });

    return url;
  }

  Future<String?> getImageFromDevice({String type = "Gallery"}) async {
    XFile? image;
    final ImagePicker _picker = ImagePicker();

    if (type != "Gallery") {
      image = await _picker.pickImage(source: ImageSource.camera);
    } else {
      image = await _picker.pickImage(source: ImageSource.gallery);
    }

    return image?.path;
  }

  Future<void> sharePost(
      String title,
      String description,
      String countryValue,
      String stateValue,
      String? imagePath,
      String? thumbnail,
      String userId, {
        String? postId,
      }) async {
    GlobalKey globalKey = GlobalKey(debugLabel: 'btm_app_bar');

    String? url;
    if (imagePath != null) {
      url = await uploadImageToFirebase(imagePath);
      thumbnail = await uploadImageThumbnailToFirebase(imagePath);
    }

    Post post = Post(
      title: title,
      description: description,
      country: countryValue,
      state: stateValue,
      image: url ?? '',
      thumbnail: thumbnail ?? '',
      uid: userId,
    );

    if (postId != null) {
      await FirebaseFirestore.instance.collection("post").doc(postId).set(post.toJson());
    } else {
      await FirebaseFirestore.instance.collection("post").add(post.toJson());
    }

    (bottomBarKey.currentWidget as BottomNavigationBar).onTap!(0);
    Loader.hide();
  }

  void deletePost(postId){
    String uid = DatabaseAuthMethods().getCurrentUserId();
    FirebaseFirestore.instance.collection("post").doc(postId).get().then((value) => {
      if(value.get("uid") == uid){
        value.reference.delete()
      }
    });
  }
}
