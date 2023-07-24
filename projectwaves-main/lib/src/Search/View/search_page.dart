import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_waves/src/Models/Post.dart';
import 'package:project_waves/src/Search/View/user_details.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../Components/ImageGrid.dart';
import '../Components/UserList.dart';
import '../Controller/SearchController.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Map<String, dynamic>> searchResult = [];
  bool isSearching = false;
  TextEditingController _searchController = TextEditingController();
  SearchPageController searchPageController = SearchPageController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 60),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search, color: Colors.black),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.purple),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.purple),
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
              onChanged: (query) {
                setState(() {
                  isSearching = query.isNotEmpty;
                });
                searchPageController.searchFromFirebase(query.toLowerCase());
              },
            ),
          ),
          Expanded(
            child: isSearching
                ? UserList(searchResult: searchPageController.searchResult)
                : FutureBuilder<List<Post>>(
              future: searchPageController.getPosts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasData) {
                  final posts = snapshot.data!;
                  return ImageGrid(posts: posts);
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                return SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
