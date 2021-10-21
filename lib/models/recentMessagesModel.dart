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
  late bool read;
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
    required this.read,
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
    read                = json['read'];
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
      'read'              :read,
      'dateTime'          :dateTime,
    };
  }
}