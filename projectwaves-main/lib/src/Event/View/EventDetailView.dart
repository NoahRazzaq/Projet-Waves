import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_waves/colors.dart';
import 'package:project_waves/font_sizes.dart';
import 'package:project_waves/src/Models/Event.dart';

import '../../Post/Components/FullScreenImagePage.dart';
import '../../Search/View/user_details.dart';
import '../Controller/EventController.dart';

class EventDetail extends StatefulWidget {
  final Event event;

  const EventDetail({required this.event});

  @override
  _EventDetailState createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {
  String username = '';
  String profilePicture = '';
  bool isHeartClicked = false;
  EventController _eventController = EventController(); // Create an instance of EventController


  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void toggleParticipation() {
    setState(() {
      _eventController.isLiked(widget.event.eventId).then((value){
        setState(() {
          isHeartClicked = value;
        });
      });
    });
  }

  void fetchUserData() async {
    final userId = widget.event.uid;
    final snapshot =
    await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (snapshot.exists) {
      setState(() {
        username = snapshot['username'];
        profilePicture = snapshot['profilePicture'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Color buttonColor = isHeartClicked ? AppColors.green : Colors.purple;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: AppColors.purple),
      ),


      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              widget.event.title,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FullScreenImagePage(
                      imageUrl: widget.event.image,
                      tag: widget.event.image, // Utilisez une valeur unique comme tag
                    ),
                  ),
                );
              },
              child: Hero(
                tag: widget.event.image, // Utilisez la même valeur que le tag dans FullScreenImagePage
                child: AspectRatio(
                  aspectRatio: 16 / 7,
                  child: CachedNetworkImage(
                    imageUrl: widget.event.image,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.0),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Exposition',
                      style: TextStyle(
                        fontSize: FontSizes.xxl,
                        color: AppColors.darkBlue,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0), // Marge horizontale de 20.0
                child:
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.event.getStartDate() != widget.event.getEndDate())
                        Column(
                          children: [
                            Text(
                              '${widget.event.getStartDate()} - ${widget.event.getEndDate()}',
                              style: TextStyle(fontSize: FontSizes.md),
                            ),
                          ],
                        )
                      else
                        Text(
                          widget.event.getStartDate(),
                          style: TextStyle(fontSize: FontSizes.md),
                        ),
                      SizedBox(width: 6.0),
                      Text(
                        '|',
                        style: TextStyle(fontSize: FontSizes.lg),
                      ),
                      SizedBox(width: 6.0),
                      Text(
                        '${widget.event.getStartTime()} - ${widget.event.getEndTime()}',
                        style: TextStyle(fontSize: FontSizes.md),
                      ),
                      SizedBox(width: 6.0),
                      Text(
                        '|',
                        style: TextStyle(fontSize: FontSizes.lg),
                      ),
                      SizedBox(width: 6.0),
                      Text(
                        '${widget.event.price} \u20AC',
                        style: TextStyle(fontSize: FontSizes.md),
                      ),
                    ],
                  ),
              ),
                  SizedBox(height: 16.0),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10.0), 
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Description',
                        style: TextStyle(fontSize: FontSizes.xl, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8.0),
                      Text(widget.event.description),
                      SizedBox(height: 16.0),
                      Text(
                        'Organized by',
                        style: TextStyle(fontSize: FontSizes.xl, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 12.0),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserDetailScreen(userId: widget.event.uid),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(profilePicture),
                              radius: 24.0,
                            ),
                            SizedBox(width: 8.0),
                            Text(
                              username,
                              style: TextStyle(
                                fontSize: FontSizes.xl,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 40.0),

                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 200.0,
                      height: 40.0,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            if(isHeartClicked){
                              _eventController.unlikeEvent(widget.event.eventId);
                            } else {
                              _eventController.likeEvent(widget.event.eventId);
                            }
                            isHeartClicked = !isHeartClicked;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          primary: buttonColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        child: Text(
                          'I participate !',
                          style: TextStyle(fontSize: FontSizes.lg),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
