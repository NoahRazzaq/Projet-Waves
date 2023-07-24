import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:project_waves/src/Models/Post.dart';

class SearchPageController {
  List<Map<String, dynamic>> searchResult = [];

  void searchFromFirebase(String query) async {
    if (query.isEmpty) {
      searchResult.clear();
      return;
    }

    final result = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isGreaterThanOrEqualTo: query)
        .where('username', isLessThanOrEqualTo: query + '\uf8ff')
        .get();

    final List<Map<String, dynamic>> users = result.docs.map((e) {
      final userData = e.data();
      final id = e.id;
      final profilePicture = userData['profilePicture'] as String?;
      return {
        'id': id,
        'username': userData['username'],
        'fullname': userData['fullname'],
        'bio': userData['bio'],
        'profilePicture': profilePicture,
      };
    }).toList();

    searchResult = users;
  }

  Future<List<Post>> getPosts() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('post')
    // .where('category', isEqualTo: 'arts')
        .get();

    final List<Post> posts = snapshot.docs.map((doc) {
      final data = doc.data();
      return Post(
        postId: doc.id,
        title: data['title'] as String? ?? '',
        description: data['description'] as String? ?? '',
        country: data['country'] as String? ?? '',
        state: data['state'] as String? ?? '',
        image: data['image'] as String? ?? '',
        thumbnail: data['thumbnail'] as String? ?? '',
        uid: data['uid'] as String? ?? '',
      );
    }).toList();

    return posts;
  }
}
