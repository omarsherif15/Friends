import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel
{
  String? postId;
  String? name;
  String? uId;
  String? profilePicture;
  String? postText;
  String? postImage;
  int? likes;
  int? comments;
  String? date;
  String? time;
  FieldValue? dateTime;


  PostModel({
    this.postId,
    this.name,
    this.uId,
    this.profilePicture,
    this.postText,
    this.postImage,
    this.likes,
    this.comments,
    this.time,
    this.date,
    this.dateTime,
});

  PostModel.fromJson(Map<String, dynamic>? json){
    postId = json!['postId'];
    name = json['name'];
    uId = json['uId'];
    profilePicture = json['profilePicture'];
    postText = json['postText'];
    postImage = json['postImage'];
    likes = json['likes'];
    comments = json['comments'];
    time = json['time'];
    date = json['date'];
  }

  Map<String, dynamic> toMap (){
    return {
      'postId':postId,
      'name':name,
      'uId' : uId,
      'profilePicture':profilePicture,
      'postText':postText,
      'postImage': postImage,
      'likes':likes,
      'comments':comments,
      'time':time,
      'date': date,
      'dateTime': dateTime,
    };
  }
}