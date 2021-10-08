import 'package:cloud_firestore/cloud_firestore.dart';


class RecentMessagesModel
{
  String? senderName;
  String? receiverName;
  String? receiverId;
  String? senderId;
  String? receiverProfilePic;
  String? senderProfilePic;
  String? recentMessageText;
  String? recentMessageImage;
  String? time;
  FieldValue? dateTime;


  RecentMessagesModel({
    this.senderName,
    this.receiverName,
    this.receiverId,
    this.senderId,
    this.recentMessageText,
    this.recentMessageImage,
    this.time,
    this.receiverProfilePic,
    this.senderProfilePic,
    this.dateTime,

  });

  RecentMessagesModel.fromJson(Map<String, dynamic> json){
    senderName          = json['senderName'];
    receiverName        = json['receiverName'];
    receiverId          = json['receiverId'];
    senderId            = json['senderId'];
    recentMessageText   = json['recentMessageText'];
    recentMessageImage  = json['recentMessageImage'];
    time                = json['time'];
    receiverProfilePic  = json['receiverProfilePic'];
    senderProfilePic    = json['senderProfilePic'];
  }

  Map<String, dynamic> toMap (){
    return {
      'senderName'        :senderName,
      'receiverName'      :receiverName,
      'receiverId'        :receiverId,
      'senderId'          :senderId,
      'recentMessageText' :recentMessageText,
      'recentMessageImage':recentMessageImage,
      'time'              :time,
      'receiverProfilePic':receiverProfilePic,
      'senderProfilePic'  :senderProfilePic,
      'dateTime'          :dateTime,
    };
  }
}