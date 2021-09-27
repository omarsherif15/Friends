import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/cubit/socialCubit.dart';
import 'package:socialapp/cubit/states.dart';
import 'package:socialapp/models/messageModel.dart';
import 'package:socialapp/models/recentMessagesModel.dart';
import 'package:socialapp/models/userModel.dart';
import 'package:socialapp/shared/constants.dart';
import 'package:socialapp/shared/styles/iconBroken.dart';

class ChatScreen extends StatelessWidget {
  final UserModel ? userModel;
  final RecentMessagesModel ? recentMessagesModel;
 ChatScreen({this.userModel, this.recentMessagesModel});
 var messageTextControl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Builder(
        builder: (context){
          String? uId,name,profilePic;
          if(userModel == null) {
        print('userModel is null');
        uId = recentMessagesModel!.senderId;
        name = recentMessagesModel!.receiverName;
        profilePic = recentMessagesModel!.profilePic;
        print(uId);
      } else if(recentMessagesModel == null)
        {
        print('recentModel is null');
        uId = userModel!.uID;
        name = userModel!.name;
        profilePic = userModel!.profilePic;
      }
      SocialCubit.get(context).getChat(uId);
          return BlocConsumer<SocialCubit,SocialStates>(
              listener: (context,state){},
              builder: (context,state){
                return Scaffold(
                  appBar: AppBar(
                    titleSpacing: 0,
                    elevation: 8,
                    leading: IconButton(
                      onPressed: (){
                        pop(context);
                      },
                      icon: Icon(IconBroken.Arrow___Left_2),
                    ),
                    automaticallyImplyLeading: false,
                    leadingWidth: 50,
                    title: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage:NetworkImage('$profilePic'),
                          radius: 20,
                        ),
                        SizedBox(width: 10,),
                        Text('$name',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),)
                      ],
                    ),
                  ),
                  body: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.separated(
                            physics: BouncingScrollPhysics(),
                              itemBuilder: (context,index){
                                var chat = SocialCubit.get(context).chat[index];
                                if(SocialCubit.get(context).model!.uID == chat.senderId)
                                  return buildMyMessage(chat,context);
                                else
                                  return buildMessage(chat,context);
                              },
                              separatorBuilder: (context,index) => SizedBox(height: 12.5,),
                              itemCount: SocialCubit.get(context).chat.length
                          )
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: myDivider(),
                        ),
                        Container(
                          height: 50,
                          child: TextFormField(
                              controller: messageTextControl,
                              textAlignVertical: TextAlignVertical.center,
                              cursorColor: Colors.black,
                              validator: (value){
                                if(value!.isEmpty)
                                  return null;
                              },
                              decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(40),borderSide: BorderSide.none),
                                  //contentPadding: EdgeInsets.all(10),
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(40),borderSide: BorderSide.none),
                                  hintText: 'Write a message...',
                                  hintStyle: TextStyle(color: Colors.grey),
                                  suffixIcon: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                          padding: EdgeInsets.zero,
                                          onPressed: (){
                                          },
                                          icon: Icon(Icons.camera_alt_outlined,color: Colors.grey,)
                                      ),
                                      IconButton(
                                          padding: EdgeInsets.zero,
                                          onPressed: (){
                                            SocialCubit.get(context).sendMessage(
                                                receiverId: uId,
                                                messageText: messageTextControl.text,
                                                date: getDate(),
                                                time: TimeOfDay.now().format(context).toString(),
                                            );
                                              SocialCubit.get(context).setRecentMessage(
                                                  receiverName:name,
                                                  senderId: SocialCubit.get(context).model!.uID,
                                                  receiverId: uId,
                                                  recentMessageText: messageTextControl.text,
                                                  profilePic: profilePic,
                                                  time: DateTime.now().toString()
                                              );
                                            messageTextControl.clear();
                                            //print(FieldValue.serverTimestamp());
                                          },
                                          icon: Icon(Icons.send,color: Colors.blue,)
                                      ),
                                    ],
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[300],
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(40))
                              )
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              );
        });
  }
  Widget buildMessage(MessageModel message,context) => Align(
    alignment: AlignmentDirectional.topStart,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(SocialCubit.get(context).showTime == true)
          Text('${TimeOfDay.now().format(context).toString()}',style: TextStyle(fontSize: 12,color: Colors.grey),),
        InkWell(
          onTap: (){
            SocialCubit.get(context).time();
          },
          child: Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  )
              ),
              child: Text('${message.messageText}')),
        ),
      ],
    ),
  );
  Widget buildMyMessage(MessageModel message,context) => Align(
   alignment: AlignmentDirectional.topEnd,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        InkWell(
          onTap: (){
            SocialCubit.get(context).time();
          },
          child: Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(0.6),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  )
              ),
              child: Text('${message.messageText}')),
        ),
        if(SocialCubit.get(context).showTime == true)
          Text('${TimeOfDay.now().format(context).toString()}',style: TextStyle(fontSize: 12,color: Colors.grey),),
      ],
    ),
 );

}
