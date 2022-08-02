class PostModel {
  late String postId;
  late String name;
  late String uId;
  late String image; // this is the image of the user who added this post
  late String dateTime;
  late String text;
  late String postImage;
  late int nbLikes; // number of likes
  late int nbComments; // number of likes

  PostModel({
    required this.postId,
    required this.name,
    required this.uId,
    required this.image,
    required this.dateTime,
    required this.text,
    required this.postImage,
    required this.nbLikes,
    required this.nbComments,
  });

  PostModel.fromJson(Map<String, dynamic> json) {
    postId = json['postId'];
    name = json['name'];
    uId = json['uId'];
    image = json['image'];
    dateTime = json['dateTime'];
    text = json['text'];
    postImage = json['postImage'];
    nbLikes = json['nbLikes'];
    nbComments = json['nbComments'];
  }

  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'name': name,
      'uId': uId,
      'image': image,
      'dateTime': dateTime,
      'text': text,
      'postImage': postImage,
      'nbLikes': nbLikes,
      'nbComments': nbComments,
    };
  }
}
