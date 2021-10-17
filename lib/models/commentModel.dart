import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel
{
  String? name;
  String? profilePicture;
  String? commentText;
  Map<String,dynamic>? commentImage;
  String? time;
  FieldValue? dateTime;


  CommentModel({
    this.name,
    this.profilePicture,
    this.commentText,
    this.commentImage,
    this.time,
    this.dateTime,
});

  CommentModel.fromJson(Map<String, dynamic>? json){
   name = json!['name'];
   profilePicture = json['profilePicture'];
   commentText = json['commentText'];
   commentImage = json['commentImage'];
   time = json['time'];
  }

  Map<String, dynamic> toMap (){
    return {
      'name':name,
      'profilePicture':profilePicture,
      'commentText':commentText,
      'commentImage': commentImage,
      'time':time,
      'dateTime':dateTime,

    };
  }
}