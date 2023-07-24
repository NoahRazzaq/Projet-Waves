import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_waves/colors.dart';
import 'package:project_waves/font_sizes.dart';
import 'package:project_waves/src/Settings/Views/setting_page.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Auth/Utils/database.dart';
import '../../Models/Post.dart';
import '../../Models/UserModel.dart';
import '../../Post/View/PostDetailView.dart';

class UserDetailScreen extends StatefulWidget {
  final String userId;

  const UserDetailScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _UserDetailScreenState createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  String username = '';
  String fullName = '';
  String biography = '';
  String email = '';
  String? image = '';
  File? profilePicture;
  List<Post> userPosts = [];



  Future<void> getUserData() async {
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .get();

    if (userData.exists) {
      setState(() {
        username = userData['username'];
        fullName = userData['fullname'];
        biography = userData['bio'];
        email = userData['email'];
        image = userData['profilePicture'];
      });
    }

    final postsSnapshot = await FirebaseFirestore.instance
        .collection('post')
        .where('uid', isEqualTo: widget.userId)
        .get();

    userPosts = postsSnapshot.docs.map((doc) {
      return Post(
        postId: doc.id,
        title: doc['title'] ?? '',
        description: doc['description'] ?? '',
        country: doc['country'] ?? '',
        state: doc['state'] ?? '',
        image: doc['image'] ?? '',
        thumbnail: doc['thumbnail'] ?? '',
        uid: doc['uid'] ?? '',
      );
    }).toList();

    setState(() {});
  }


  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
    '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  void sendEmail() async {
    UserModel? currentUser = await DatabaseAuthMethods().getCurrentUser();
    if (currentUser == null) {
      throw 'User not logged in';
    }

    final String username = currentUser.username;
    final String subject = '$username from Blossom !';

    final Map<String, String> queryParams = {
      'subject': subject,
      'to': email
    };

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      query: encodeQueryParameters(queryParams),
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      throw 'Could not launch email';
    }
  }

  bool showPosts = true;
  //bool showEvents = false;
  //bool showLikes = false;
  String displayText = 'Posts';
  void switchToPosts() {
    setState(() {
      showPosts = true;
      //showEvents = false;
      //showLikes = false;
      displayText = 'Posts';
    });
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'User Profile',
          style: TextStyle(
            color: Colors.black, // Couleur du texte du titre
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: AppColors.purple),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: Align(
                  alignment: Alignment.center,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: profilePicture == null
                            ? CachedNetworkImageProvider(image!)
                            : Image.file(profilePicture!).image,
                      ),
                      SizedBox(width: 16.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$username',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            LayoutBuilder(
                              builder: (context, constraints) {
                                double fontSize = constraints.maxHeight > 100 ? FontSizes.xs : FontSizes.sm;
                                return Text(
                                  '$biography',
                                  style: TextStyle(fontSize: fontSize),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 8.0),
                      Column(
                        children: [
                          InkWell(
                            onTap: sendEmail,
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.green,
                                shape: BoxShape.circle,
                              ),
                              padding: EdgeInsets.all(12.0),
                              child: Icon(
                                CupertinoIcons.paperplane,
                                color: Colors.white,
                                size: 24.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    displayText,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: switchToPosts,
                        icon: Icon(Icons.grid_view),
                        color: showPosts ? AppColors.purple : Colors.grey,
                      ),
                  //    IconButton(
                  //      onPressed: switchToEvents,
                  //      icon: Icon(Icons.event),
                  //      color: showEvents ? AppColors.purple : Colors.grey,
                  //    ),
                  //    IconButton(
                  //      onPressed: switchToLikes,
                  //      icon: Icon(CupertinoIcons.heart_circle),
                  //      color: showLikes ? AppColors.purple : Colors.grey,
                  //    ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: userPosts.length,
                itemBuilder: (context, index) {
                  final post = userPosts[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PostDetailView(post: post),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(post.thumbnail),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
