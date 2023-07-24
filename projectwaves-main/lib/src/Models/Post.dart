class Post {
  String postId;
  String title;
  String description;
  String country;
  String state; // Add the 'state' parameter
  String image;
  String thumbnail;
  String uid;

  Post({
    this.postId = "",
    required this.title,
    required this.description,
    required this.country,
    required this.state,
    required this.image,
    required this.thumbnail,
    required this.uid,
  });

  Map<String, dynamic> toJson() => {
    "title": title,
    "description": description,
    "country": country,
    "state": state,
    "image": image,
    "thumbnail": thumbnail,
    "uid": uid,
  };
}
