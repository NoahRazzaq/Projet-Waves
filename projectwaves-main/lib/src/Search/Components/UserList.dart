
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_waves/font_sizes.dart';

import '../View/user_details.dart';

class UserList extends StatelessWidget {
  final List<Map<String, dynamic>> searchResult;

  const UserList({Key? key, required this.searchResult}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: searchResult.length,
      itemBuilder: (context, index) {
        final user = searchResult[index];
        final profilePicture = user['profilePicture'] as String?;

        return ListTile(
          leading: profilePicture != null
              ? CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(profilePicture),
            radius: 30,
          )
              : CircleAvatar(
            backgroundColor: Colors.purple,
            radius: 30,
          ),
          title: Text(
            user['username'] as String,
            style: TextStyle(
              fontSize: FontSizes.lg,
              fontFamily: 'Inter',
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            user['fullname'] as String,
            style: TextStyle(
              fontSize: FontSizes.sm,
              fontFamily: 'Inter',
              fontWeight: FontWeight.bold,
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserDetailScreen(userId: user['id'] as String),
              ),
            );
          },
        );
      },
    );
  }
}
