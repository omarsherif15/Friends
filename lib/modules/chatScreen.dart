import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/cubit/socialCubit.dart';
import 'package:socialapp/cubit/states.dart';
import 'package:socialapp/models/messageModel.dart';
import 'package:socialapp/models/recentMessagesModel.dart';
import 'package:socialapp/models/userModel.dart';
import 'package:socialapp/shared/constants.dart';
import 'package:socialapp/translations/local_keys.g.dart';
import 'package:uuid/uuid.dart';

class ChatScreen extends StatefulWidget {
  final UserModel? userModel;
  final RecentMessagesModel? recentMessagesModel;
  String? uId;

  ChatScreen({this.userModel, this.recentMessagesModel, this.uId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}


class _ChatScreenState extends State<ChatScreen> {
  var messageTextControl = TextEditingController();

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
  Scrollable.ensureVisible(context);
  super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      if (widget.userModel == null)
        print('userModel is null');
      else if (widget.recentMessagesModel == null) print('recentModel is null');
      SocialCubit.get(context).getChat(widget.uId);
      SocialCubit.get(context).getUserData(widget.uId);
      return BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {},
          builder: (context, state) {
            var uuid = Uuid();
            dynamic messageImage = SocialCubit.get(context).messageImage;
            UserModel? user = SocialCubit.get(context).userModel;
            return user == null
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Scaffold(
                    appBar: AppBar(
                      titleSpacing: 0,
                      elevation: 8,
                      title: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage('${user.profilePic}'),
                            radius: 20,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            '${user.name}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                    body: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          Expanded(
                              child: ListView.separated(
                                controller: scrollController,
                                  physics: BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    var chat = SocialCubit.get(context).chat[index];
                                    if (SocialCubit.get(context).model!.uID == chat.senderId)
                                      return buildMyMessage(chat, context);
                                    else
                                      return buildMessage(chat, context);
                                  },
                                  separatorBuilder: (context, index) =>
                                      SizedBox(
                                        height: 12.5,
                                      ),
                                  itemCount:
                                      SocialCubit.get(context).chat.length)),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child:   SocialCubit.get(context).isLoading ?
                            LinearProgressIndicator(color: Colors.blueAccent,) : myDivider(),
                          ),
                          if(messageImage != null)
                            Padding(
                            padding: const EdgeInsetsDirectional.only(bottom: 8.0),
                            child: Align(
                              alignment: AlignmentDirectional.topStart,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 100,
                                    height: 100,
                                    child:Image.file(
                                    messageImage,
                                    fit: BoxFit.cover,width: 100),
                                  ),
                                  SizedBox(width: 5,),
                                  Container(
                                    width: 30,
                                    height: 30,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.grey[300],
                                      child: IconButton(
                                          onPressed: (){
                                            SocialCubit.get(context).popMessageImage();
                                          },
                                          icon: Icon(Icons.close),iconSize: 15,),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 50,
                            child: TextFormField(
                                controller: messageTextControl,
                                textAlignVertical: TextAlignVertical.center,
                                cursorColor: SocialCubit.get(context).textColor,
                                style: TextStyle(color: SocialCubit.get(context).textColor),
                                validator: (value) {
                                  if (value!.isEmpty) return null;
                                },
                                decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(40),
                                        borderSide: BorderSide.none),
                                    //contentPadding: EdgeInsets.all(10),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(40),
                                        borderSide: BorderSide.none),
                                    hintText: LocaleKeys.writeMessage.tr(),
                                    hintStyle: TextStyle(color: Colors.grey),
                                    suffixIcon: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                            padding: EdgeInsets.zero,
                                            onPressed: () {
                                              SocialCubit.get(context).getMessageImage();
                                            },
                                            icon: Icon(Icons.camera_alt_outlined, color: Colors.grey,)),
                                        IconButton(
                                            padding: EdgeInsets.zero,
                                            onPressed: () {
                                              if(messageImage == null)
                                                SocialCubit.get(context).sendMessage(
                                                  messageId: uuid.v4(),
                                                  receiverId: widget.uId,
                                                  messageText: messageTextControl.text,
                                                  date: getDate(),
                                                  time: TimeOfDay.now().format(context).toString(),
                                                );
                                              else
                                                SocialCubit.get(context).uploadMessagePic(
                                                    messageId: uuid.v4(),
                                                    receiverId: widget.uId,
                                                    messageText: messageTextControl.text == '' ? null : messageTextControl.text,
                                                    date: getDate(),
                                                    time: TimeOfDay.now().format(context).toString(),
                                                );
                                              SocialCubit.get(context).sendFCMNotification(
                                                      token: user.token,
                                                      senderName: SocialCubit.get(context).model!.name,
                                                      messageText: messageTextControl.text,
                                                      messageImage: SocialCubit.get(context).imageURL,
                                              );
                                              SocialCubit.get(context).setRecentMessage(
                                                      receiverName: user.name,
                                                      receiverId: user.uID,
                                                      recentMessageText: messageTextControl.text,
                                                      recentMessageImage: SocialCubit.get(context).imageURL,
                                                      receiverProfilePic: user.profilePic,
                                                      time: DateTime.now().toString());
                                              messageTextControl.clear();
                                              SocialCubit.get(context).popMessageImage();
                                            },
                                            icon: Icon(
                                              Icons.send,
                                              color: Colors.blue,
                                            )),
                                      ],
                                    ),
                                    filled: true,
                                    fillColor: SocialCubit.get(context).textFieldColor,
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(40)))),
                          ),
                        ],
                      ),
                    ),
                  );
          });
    });
  }

  Widget buildMessage(MessageModel message, context) => Align(
        alignment: AlignmentDirectional.topStart,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (SocialCubit.get(context).showTime == true)
              Text(
                '${TimeOfDay.now().format(context).toString()}',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            InkWell(
              onTap: () {
                SocialCubit.get(context).time();
              },
              onLongPress: () async{
                final result = await showDialog(context: context, builder: (context) => alertDialog(context));
               switch(result){
                 case 'DELETE FOR EVERYONE':
                   SocialCubit.get(context).deleteForEveryone(
                       messageId: message.messageId,
                       receiverId: message.receiverId
                   );
                   break;
                 case 'DELETE FOR ME':
                   SocialCubit.get(context).deleteForMe(
                       messageId: message.messageId,
                       receiverId: message.receiverId
                   );
                   break;
               }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  message.messageText != null && message.messageImage != null ?
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          padding: EdgeInsets.all(8),
                          width: intToDouble(message.messageImage!['width']) < 230 ?
                          intToDouble(message.messageImage!['width']) : 230,
                          height: intToDouble(message.messageImage!['height']) < 250 ?
                          intToDouble(message.messageImage!['height']) : 250,
                          decoration: BoxDecoration(
                              color: SocialCubit.get(context).messageColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                              )
                          ),
                          child: imagePreview(message.messageImage!['image'])),
                      Container(
                          width: 190,
                          padding: EdgeInsets.symmetric(horizontal: 15,vertical: 8),
                          decoration: BoxDecoration(
                              color: SocialCubit.get(context).messageColor,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              )),
                          child: Text('${message.messageText}',style: TextStyle(color: SocialCubit.get(context).textColor))),
                    ],) :
                  message.messageImage != null ?
                  Container(
                      padding: EdgeInsets.all(8),
                      width: intToDouble(message.messageImage!['width']) < 230 ?
                      intToDouble(message.messageImage!['width']) : 230,
                      height: intToDouble(message.messageImage!['height']) < 250 ?
                      intToDouble(message.messageImage!['height']) : 250,
                      decoration: BoxDecoration(
                          color: SocialCubit.get(context).messageColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          )
                      ),
                      child: imagePreview(message.messageImage!['image'])) :
                  message.messageText != null ?
                  Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          color: SocialCubit.get(context).messageColor,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          )),
                      child: Text('${message.messageText}',style: TextStyle(color: SocialCubit.get(context).textColor))) : Container(height: 0,width: 0,)
                ],
              ),
            ),
          ],
        ),
      );

  Widget buildMyMessage(MessageModel message, context) => Align(
        alignment: AlignmentDirectional.topEnd,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            InkWell(
              onTap: () {
                SocialCubit.get(context).time();
              },
              onLongPress: () async{
                final result = await showDialog(context: context, builder: (context) => alertDialog(context));
                switch(result){
                  case 'DELETE FOR EVERYONE':
                    SocialCubit.get(context).deleteForEveryone(
                        messageId: message.messageId,
                        receiverId: message.receiverId
                    );
                    break;
                  case 'DELETE FOR ME':
                  SocialCubit.get(context).deleteForMe(
                      messageId: message.messageId,
                      receiverId: message.receiverId
                  );
                    break;
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  message.messageText != null && message.messageImage != null ?
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                            width: intToDouble(message.messageImage!['width']) < 230 ?
                            intToDouble(message.messageImage!['width']) : 230,
                            height: intToDouble(message.messageImage!['height']) < 250 ?
                            intToDouble(message.messageImage!['height']) : 250,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                child: imagePreview(message.messageImage!['image']))),
                        Container(
                          width: 190,
                            padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                            decoration: BoxDecoration(
                                color: SocialCubit.get(context).myMessageColor,
                                borderRadius: BorderRadius.only(
                                  topLeft:Radius.circular(10) ,
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                )),
                            child: Text('${message.messageText}',style: TextStyle(color: Colors.white))),
                      ],) :
                  message.messageImage != null ?
                    Container(
                        padding: EdgeInsets.all(8),
                        width: 190,
                        height: 250,
                        decoration: BoxDecoration(
                          color: SocialCubit.get(context).myMessageColor,
                            borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                    )
                        ),
                        child: imagePreview(message.messageImage!['image'])) :
                  message.messageText != null ?
                    Container(
                        padding: EdgeInsets.all(13),
                        decoration: BoxDecoration(
                            color: SocialCubit.get(context).myMessageColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            )),
                        child: Text('${message.messageText}',style: TextStyle(color: Colors.white))) : Container(height: 0,width: 0,)


                ],
              ),
            ),
            if (SocialCubit.get(context).showTime == true)
              Text(
                '${TimeOfDay.now().format(context).toString()}',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
          ],
        ),
      );

  Widget alertDialog(context) {
    return AlertDialog(
      backgroundColor: SocialCubit.get(context).backgroundColor.withOpacity(1),
      content: Padding(
        padding: const EdgeInsetsDirectional.only(start: 15,top: 15),
        child: Text(LocaleKeys.deleteMessage.tr(),style: TextStyle(fontSize: 17,color: SocialCubit.get(context).textColor,),),
      ),
      elevation: 8,
      contentPadding: EdgeInsets.all(15),
      actions: [
        TextButton(
            onPressed: (){
              Navigator.of(context).pop('DELETE FOR EVERYONE');
            },
            child: Text('DELETE FOR EVERYONE')
        ),
        TextButton(
            onPressed: (){
              Navigator.of(context).pop('DELETE FOR ME');
            },
            child: Text('DELETE FOR ME')
        ),
        TextButton(
            onPressed: (){
             pop(context);
            },
            child: Text('CANCEL')
        ),
      ],

    );
  }
}
