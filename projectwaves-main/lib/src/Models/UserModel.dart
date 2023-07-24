class UserModel {
  String email;
  String username;
  String fullname;
  String bio;
  String profilePicture;
  List<String> likedContent;
  List<String> likedEvents;

  UserModel({
    required this.email,
    required this.username,
    required this.fullname,
    required this.bio,
    required this.profilePicture,
    this.likedContent = const [],
    this.likedEvents = const [],
  });

  Map<String, dynamic> toJson() => {
    "email": email,
    "username": username,
    "fullname": fullname,
    "bio": bio,
    "profilePicture": profilePicture,
    "likedContent": likedContent,
    "likedEvents": likedEvents,
  };

  UserModel.fromJson(Map<String, dynamic> json) :
    email = json["email"],
    username = json["username"],
    fullname = json["fullname"],
    bio = json["bio"],
    profilePicture = json["profilePicture"],
    likedContent = json["likedContent"].cast<String>(),
    likedEvents = json["likedEvents"].cast<String>();
}
