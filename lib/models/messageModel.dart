import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel
{
  String? messageId;
  String? receiverId;
  String? senderId;
  String? messageText;
  Map<String,dynamic>? messageImage;
  String? time;
  String? date;
  FieldValue? dateTime;


  MessageModel({
    this.messageId,
    this.receiverId,
    this.senderId,
    this.messageText,
    this.messageImage,
    this.time,
    this.date,
    this.dateTime

  });

  MessageModel.fromJson(Map<String, dynamic> json){
    messageId     = json['messageId'];
    receiverId    = json['receiverId'];
    senderId      = json['senderId'];
    messageText   = json['messageText'];
    messageImage  = json['messageImage'];
    time          = json['time'];
    date          = json['date'];
  }

  Map<String, dynamic> toMap (){
    return {
      'messageId'   :messageId,
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