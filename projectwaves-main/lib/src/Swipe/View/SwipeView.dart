import 'dart:developer';
import 'dart:ui';

import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventsubscriber/eventsubscriber.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sliding_up_panel/sliding_up_panel_widget.dart';
import 'package:event/event.dart';
import 'package:project_waves/src/Models/Post.dart';

import '../../Auth/Utils/database.dart';
import '../../Search/View/user_details.dart';
import '../Components/rounded_bar.dart';
import '../Components/swipeButton.dart';

class SwipeView extends StatefulWidget {
  const SwipeView({super.key});

  @override
  _SwipeViewState createState() => _SwipeViewState();
}

class ImageDescription {
  String description = "";
  String title = "";
  String username = "";
  String image = "";
  String uid = "";
  bool isModalOpen = false;

  var valueChanged = Event();

  void changeDescription(String description){
    this.description = description;
    valueChanged.broadcast();
  }

  void changeTitle(String title){
    this.title = title;
    valueChanged.broadcast();
  }

  void changeUsername(String username) {
    this.username = username;
    valueChanged.broadcast();
  }

  void changeImage(String image) {
    this.image = image;
    valueChanged.broadcast();
  }

  void changeUid(String uid) {
    this.uid = uid;
    valueChanged.broadcast();
  }

  void openModal(){
    this.isModalOpen = true;
    valueChanged.broadcast();
  }

  void closeModal(){
    this.isModalOpen = false;
    valueChanged.broadcast();
  }
}

class _SwipeViewState extends State<SwipeView> with TickerProviderStateMixin {


  // Crée une liste vide pour stocker les URLs
  List<Container> cards = [];
  List<Post> allPosts = [];
  final _panelController = SlidingUpPanelController();
  var imageDescription = ImageDescription();

  var _isLoaded = false;
  var isShowingButtons = false;
  final PageController _pageController = PageController();
  final AppinioSwiperController controller = AppinioSwiperController();


  late AnimationController spinnerController;
  // Exécute la requête Cloud Firestore lorsque le widget est créé
  @override
  void initState() {
    spinnerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addListener(() {
      if(!_isLoaded){
        //setState(() {});
      }
    });
    spinnerController.repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    spinnerController.dispose();
    super.dispose();
  }

  Future<List<Container>> _getImagesList() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference imagesCollection = firestore.collection('post');
    QuerySnapshot snapshot = await imagesCollection.get();
    var first = true;
    for (var document in snapshot.docs) {
      cards.add(
          Container(
            child: GestureDetector(
            onTap: () => {
              if (SlidingUpPanelStatus.expanded == _panelController.status ||
                  SlidingUpPanelStatus.anchored == _panelController.status) {
                _panelController.collapse(),
              } else {
                _panelController.anchor(),

              }
            },
            child: CachedNetworkImage(
              imageUrl: document.get("image"),
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              placeholder: (context, url) {
                return Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(document.get("thumbnail")),
                          fit: BoxFit.cover
                      )
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.0)),
                    ),),
                );
              },
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          )
      )
      );
      allPosts.add(Post(
        postId: document.id,
        title: document.get("title"),
        description: document.get("description"),
        country: document.get("country"),
        state: document.get("state"),
        image: document.get("image"),
        thumbnail: document.get("thumbnail"),
        uid: document.get("uid"),
      ));
  }
    imageDescription.changeTitle(allPosts.last.title);
    imageDescription.changeDescription(allPosts.last.description);
    imageDescription.changeUid(allPosts.last.uid);

    if(!_isLoaded){
      setState(() {
        _isLoaded = true;
      });
    }
    return cards;
  }
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
              FutureBuilder<List<Container>>(
                  future: _getImagesList(),
                  builder: (BuildContext context, AsyncSnapshot<List<Container>> snapshot) {
                    if (snapshot.hasData) {
                      return Container(
                          child: SizedBox(
                            height: MediaQuery
                                .of(context)
                                .size
                                .height * 1,
                            child: AppinioSwiper(
                              unlimitedUnswipe: true,
                              controller: controller,
                              unswipe: _unswipe,
                              cards: snapshot.data,
                              onSwipe: _swipe,
                              padding: const EdgeInsets.only(
                              ),
                            ),
                          )
                      );
                    }
                    else {
                      return const Text("LOADING...");
                    }
                  }
              ),
              EventSubscriber(
                event: imageDescription.valueChanged,
                builder: (context, args) => SlidingUpPanelWidget(
              anchor: 0.3,
              panelController: _panelController,
              controlHeight: 0,
              enableOnTap: true,
              onStatusChanged: (status)=>{
                if(status == SlidingUpPanelStatus.collapsed){
                  imageDescription.closeModal()
                } else {
                  imageDescription.openModal()
                }
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 15.0),
                decoration: const ShapeDecoration(
                  color: Color(0x80000000),
                  shadows: [
                    BoxShadow(
                      blurRadius: 5.0,
                      spreadRadius: 2.0,
                      color: Color(0x00816c6c),
                    )
                  ],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    ),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      height: 50.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const <Widget>[
                          RoundedBarIcon(
                            size: 80,
                            color: Colors.white,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: 8.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 20.0),
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(imageDescription.image),
                                radius: 15,
                              ),
                            ),
                            SizedBox(width: 8),
                            GestureDetector(
                              onTap: () {
                                if (imageDescription.uid != null && imageDescription.uid.isNotEmpty) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          UserDetailScreen(
                                            userId: imageDescription.uid,
                                          ),
                                    ),
                                  );
                                }
                              },
                              child: Padding(
                                padding: EdgeInsets.only(left: 5.0),
                                child:  Text(
                                  imageDescription.username,
                                  style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 10),
                        Container(
                          child: Text(
                            imageDescription.title,
                            style: TextStyle(fontSize: 19, color: Colors.white),
                          ),
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsetsDirectional.only(start: 25),
                        ),
                        SizedBox(height: 5),

                        Container(
                          child: Text(
                            imageDescription.description,
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsetsDirectional.only(start: 25),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          EventSubscriber(
            event: imageDescription.valueChanged,
            builder: (context, args) =>
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: (_isLoaded && imageDescription.isModalOpen) ? Row() : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        unswipeButton(controller),
                        const SizedBox(
                          width: 20,
                        ),
                        swipeLeftButton(controller),
                        const SizedBox(
                          width: 40,
                        ),
                        swipeRightButton(controller),
                        const SizedBox(
                          width: 60,
                        ),
                      ],
                    ),
                  )
                ),
              ],
        )
    );
  }

  void _swipe(int index, AppinioSwiperDirection direction) async {
    if(index > 0){
      imageDescription.changeTitle(allPosts[index-1].title);
      imageDescription.changeDescription(allPosts[index-1].description);
      imageDescription.changeUid(allPosts[index-1].uid);
      fetchUserData(allPosts[index-1].uid);
    }
    String postId = allPosts[index].postId;
    var currentUser = await DatabaseAuthMethods().getCurrentUser();
    if(currentUser != null){
      if(direction == AppinioSwiperDirection.right){
        if(!currentUser.likedContent.contains(postId)){
          currentUser.likedContent.add(postId);
        }
      } else if(direction == AppinioSwiperDirection.left){
        if(currentUser.likedContent.contains(postId)){
          currentUser.likedContent.remove(postId);
        }
      }
      DatabaseAuthMethods().addUserInfoToDB(
          FirebaseAuth.instance.currentUser!.uid, currentUser.toJson());
      DatabaseAuthMethods().setCurrentUser();
    }
    log("the card was swiped to the: " + direction.name);
  }

  Future<void> fetchUserData(String uid) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference userCollection = firestore.collection('users');
    DocumentSnapshot snapshot = await userCollection.doc(uid).get();

    if (snapshot.exists) {
      String username = snapshot.get("username");
      String profilePicture = snapshot.get("profilePicture");
      imageDescription.changeUsername(username);
      imageDescription.changeImage(profilePicture);
    } else {
      log('User not found');
    }
  }

  void _unswipe(bool unswiped) {
    if (unswiped) {
      log("SUCCESS: card was unswiped");
    } else {
      log("FAIL: no card left to unswipe");
    }
  }
}
