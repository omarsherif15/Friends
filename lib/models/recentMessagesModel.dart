import 'package:cloud_firestore/cloud_firestore.dart';


class RecentMessagesModel
{
  String? uID;
  String? receiverName;
  String? receiverId;
  String? senderId;
  String? recentMessageText;
  String? time;
  String? profilePic;
  FieldValue? dateTime;


  RecentMessagesModel({
    this.uID,
    this.receiverName,
    this.receiverId,
    this.senderId,
    this.recentMessageText,
    this.time,
    this.profilePic,
    this.dateTime

  });

  RecentMessagesModel.fromJson(Map<String, dynamic> json){
    receiverName        = json['receiverName'];
    receiverId          = json['receiverId'];
    senderId            = json['senderId'];
    recentMessageText   = json['recentMessageText'];
    time                = json['time'];
    profilePic          = json['profilePic'];
  }

  Map<String, dynamic> toMap (){
    return {
      'uId'               :receiverId,
      'receiverName'      :receiverName,
      'receiverId'        :receiverId,
      'senderId'          :senderId,
      'recentMessageText' :recentMessageText,
      'time'              :time,
      'profilePic'        :profilePic,
      'dateTime'          :dateTime
    };
  }
}