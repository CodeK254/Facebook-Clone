import "package:facebook/models/user.dart";

class Post{
  int? id;
  String? caption;
  String? image;
  int? likesCount;
  int? commentsCount;
  User? user;
  bool? selfLiked;

  Post({
    this.id,
    this.caption,
    this.image,
    this.likesCount,
    this.commentsCount,
    this.user,
    this.selfLiked,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json["id"],
      caption: json["caption"],
      image: json["image"],
      likesCount: json["likes_count"],
      commentsCount: json["comments_count"],
      selfLiked: json["likes"].length > 0,
      user: User(
        id: json["user"]["id"], 
        name: json["user"]["name"],
        image: json["user"]["image"],
      ),
    );
  }
}