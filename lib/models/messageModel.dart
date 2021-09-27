import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel
{
  String? receiverId;
  String? senderId;
  String? messageText;
  String? messageImage;
  String? time;
  String? date;
  FieldValue? dateTime;


  MessageModel({
    this.receiverId,
    this.senderId,
    this.messageText,
    this.messageImage,
    this.time,
    this.date,
    this.dateTime

  });

  MessageModel.fromJson(Map<String, dynamic> json){
    receiverId    = json['receiverId'];
    senderId      = json['senderId'];
    messageText   = json['messageText'];
    messageImage  = json['messageImage'];
    time          = json['time'];
    date          = json['date'];
  }

  Map<String, dynamic> toMap (){
    return {
      'receiverId'  :receiverId,
      'senderId'    :senderId,
      'messageText' :messageText,
      'messageImage':messageImage,
      'time'        :time,
      'date'        :date,
      'dateTime'    :dateTime
    };
  }
}