import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_waves/src/Models/Post.dart';
import 'package:project_waves/src/Search/View/user_details.dart';
import '../../Auth/Utils/database.dart';
import '../Components/FullScreenImagePage.dart';
import '../Controller/PostController.dart';
import 'PostForm.dart';

class PostDetailView extends StatefulWidget {
  final Post post;

  const PostDetailView({Key? key, required this.post}) : super(key: key);

  @override
  _PostDetailViewState createState() => _PostDetailViewState();
}

class _PostDetailViewState extends State<PostDetailView> {
  String username = '';
  String profilePicture = '';
  String userId = DatabaseAuthMethods().getCurrentUserId();
  final PostController postController = PostController();


  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void fetchUserData() async {
    final userId = widget.post.uid;
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();
    if (snapshot.exists) {
      setState(() {
        username = snapshot['username'];
        profilePicture = snapshot['profilePicture'];
      });
    }
  }

  void navigateToUserDetailScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserDetailScreen(userId: widget.post.uid),
      ),
    );
  }

  void closePostDetailScreen(){
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.purple),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('Post Detail'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: GestureDetector(
                onTap: navigateToUserDetailScreen,
                child: Container(
                  color: Colors.transparent,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: CachedNetworkImageProvider(profilePicture),
                        ),
                        SizedBox(width: 12),
                        Text(
                          username,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                )
              ),

            ),
            Hero(
              tag: 'image_${widget.post.postId}',
              child: AspectRatio(
                aspectRatio: 15 / 12,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FullScreenImagePage(
                          imageUrl: widget.post.image,
                          tag: 'image_${widget.post.postId}',
                        ),
                      ),
                    );
                  },
                  child: CachedNetworkImage(
                    imageUrl: widget.post.image,
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
              padding: const EdgeInsets.all(11.0),
              child: Text(
                '${widget.post.country}, ${widget.post.state}',
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.post.title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.post.description,
                style: TextStyle(fontSize: 16),
              ),
            ),
            if(widget.post.uid == userId)...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        alignment: Alignment.center,
                        backgroundColor: Colors.blue,
                      ),
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return PostForm(
                            post: widget.post,
                          );
                        }
                        ));
                      },
                      child: const Icon(Icons.edit)
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        alignment: Alignment.center,
                        backgroundColor: Colors.red,
                      ),
                      onPressed: (){
                        postController.deletePost(widget.post.postId);
                        closePostDetailScreen();
                      },
                      child: const Icon(Icons.delete)
                  ),
                ],
              )
            ]
          ],
        ),
      ),
    );
  }
}
