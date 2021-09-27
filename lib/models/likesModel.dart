import 'package:cloud_firestore/cloud_firestore.dart';

class LikesModel
{
  String?uId;
  String? name;
  String? profilePicture;
  FieldValue? dateTime;


  LikesModel({
    this.uId,
    this.name,
    this.profilePicture,
    this.dateTime,
});

  LikesModel.fromJson(Map<String, dynamic>? json){
    uId = json!['uId'];
   name = json['name'];
   profilePicture = json['profilePicture'];
  }

  Map<String, dynamic> toMap (){
    return {
      'uId' : uId,
      'name':name,
      'profilePicture':profilePicture,
      'dateTime':dateTime,

    };
  }
}