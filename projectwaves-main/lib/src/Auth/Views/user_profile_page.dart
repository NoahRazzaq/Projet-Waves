import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_waves/colors.dart';
import 'package:project_waves/src/Auth/Views/logout_page.dart';
import 'package:project_waves/src/Models/UserModel.dart';
import 'package:project_waves/src/Settings/Views/setting_page.dart';
import 'package:project_waves/font_sizes.dart';

import '../../Event/Components/EventCard.dart';
import '../../Event/Controller/EventController.dart';
import '../../Event/View/EventForm.dart';
import '../../Models/Post.dart';
import '../../Models/Event.dart';
import '../../Post/View/PostDetailView.dart';
import '../../Post/View/PostForm.dart';
import '../Utils/database.dart';

class UserProfileView extends StatefulWidget {
  const UserProfileView({Key? key}) : super(key: key);

  @override
  _UserProfileViewState createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {
  String username = '';
  String fullName = '';
  String biography = '';
  String email = '';
  String? image = '';
  List<String> likedContent = [];
  File? profilePicture;
  List<Post> userPosts = [];
  List<Post> likedPosts = [];
  List<Event> likedEvents = [];
  List<Event> userEvents = [];
  bool showPosts = true;
  bool showEvents = false;
  bool showLikes = false;
  String displayText = 'Posts';
  EventController _eventController = EventController();



  Future<void> getUserData() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    final userData = await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userData.exists) {
      setState(() {
        username = userData['username'];
        fullName = userData['fullname'];
        biography = userData['bio'];
        email = userData['email'];
        image = userData['profilePicture'];
        likedContent = userData["likedContent"].cast<String>();
      });
    }
    UserModel? account = await DatabaseAuthMethods().getCurrentUser();
    if(account == null) {
      throw Exception("Local stored user can't be null");
    }
    final likedPostsSnapshots = FirebaseFirestore.instance.collection('post')
        .where(
        FieldPath.documentId, whereIn: account.likedContent
    );
    likedPostsSnapshots.get().then((value) => likedPosts = value.docs.map((doc) {
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
    }).toList());
    final postsSnapshot = await FirebaseFirestore.instance
        .collection('post')
        .where('uid', isEqualTo: userId)
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

    final eventsSnapshot =
    await FirebaseFirestore.instance.collection('events').where('uid', isEqualTo: userId).get();

    userEvents = eventsSnapshot.docs.map((doc) {
      return Event.fromJson(doc.data());
    }).toList();

    setState(() {});
  }

  void switchToPosts() {
    setState(() {
      showPosts = true;
      showEvents = false;
      showLikes = false;
      displayText = 'Posts';
    });
  }

  void switchToEvents() {
    setState(() {
      showPosts = false;
      showEvents = true;
      showLikes = false;
      displayText = 'Events';
    });
  }

  void switchToLikes() {
    setState(() {
      showPosts = false;
      showEvents = false;
      showLikes = true;
      displayText = 'Likes';
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 40.0, 16.0, 0.0),
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
                                double fontSize = constraints.maxHeight > 100 ? 12 : 14;
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
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SettingPage(),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.blueGrey,
                                shape: BoxShape.circle,
                              ),
                              padding: EdgeInsets.all(12.0),
                              child: Icon(
                                CupertinoIcons.gear,
                                color: Colors.white,
                                size: 24.0,
                              ),
                            ),
                          ),
                          SizedBox(height: 10.0), // Espacement entre les deux boutons
                          InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return Container(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ListTile(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => PostForm(),
                                              ),
                                            );
                                          },
                                          title: Text('New Post'),
                                          leading: Icon(
                                            Icons.create,
                                            color: AppColors.purple,
                                          ),
                                        ),
                                        ListTile(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => EventForm(),
                                              ),
                                            );
                                          },
                                          title: Text('New Event'),
                                          leading: Icon(
                                            Icons.event,
                                            color: AppColors.purple,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.purple,
                                shape: BoxShape.circle,
                              ),
                              padding: EdgeInsets.all(12.0),
                              child: Icon(
                                Icons.add,
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
              SizedBox(height: 16.0),
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
                      IconButton(
                        onPressed: switchToEvents,
                        icon: Icon(Icons.event),
                        color: showEvents ? AppColors.purple : Colors.grey,
                      ),
                      IconButton(
                        onPressed: switchToLikes,
                        icon: Icon(CupertinoIcons.heart_circle),
                        color: showLikes ? AppColors.purple : Colors.grey,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              if (showPosts) ...[
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
                    Post post = userPosts[index];
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
                            image: CachedNetworkImageProvider(post.image),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ] else if (showEvents) ...[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8.0),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: userEvents.length,
                      itemBuilder: (context, index) {
                        Event event = userEvents[index];
                        return GestureDetector(
                          onTap: () => _eventController.navigateToEventDetail(event, context),
                          child: EventCard(
                            event: event,
                            onTap: () {
                              _eventController.navigateToEventDetail(event, context);
                            }, // Add your custom action
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ] else if (showLikes) ...[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8.0),
                    GridView.builder(
                      shrinkWrap: true, // Added to prevent GridView from taking infinite height
                      physics: const NeverScrollableScrollPhysics(), // Added to prevent GridView from scrolling
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                      ),
                      itemCount: likedPosts.length,
                      itemBuilder: (context, index) {
                        Post post = likedPosts[index];
                        return GestureDetector(
                          onTap: () {
                            // Navigate to PostDetailView when image is tapped
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
                                image: CachedNetworkImageProvider(post.image),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
