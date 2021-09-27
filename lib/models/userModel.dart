import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel
{
  String? uID;
  String? name;
  String? phone;
  String? email;
  String? bio;
  String? coverPic;
  String? profilePic;
  FieldValue? dateTime;


    UserModel({
    this.uID,
    this.phone,
    this.email,
    this.name,
    this.bio,
    this.coverPic,
    this.profilePic,
    this.dateTime
});

  UserModel.fromJson(Map<String, dynamic>? json){
   uID = json!['uId'];
   name = json['name'];
   phone = json['phone'];
   email = json['email'];
   bio = json['bio'];
   coverPic = json['coverPic'];
   profilePic = json['profilePic'];
  }

  Map<String, dynamic> toMap (){
    return {
      'uId': uID,
      'name':name,
      'phone':phone,
      'email':email,
      'bio': bio,
      'profilePic':profilePic,
      'coverPic': coverPic,
      'dateTime':dateTime
    };
  }
}