import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:socialapp/cubit/socialCubit.dart';
import 'package:socialapp/cubit/states.dart';
import 'package:socialapp/layouts/sociallayout.dart';
import 'package:socialapp/models/recentMessagesModel.dart';
import 'package:socialapp/models/userModel.dart';
import 'package:socialapp/modules/chatScreen.dart';
import 'package:socialapp/shared/component.dart';
import 'package:socialapp/shared/constants.dart';
import 'package:socialapp/translations/local_keys.g.dart';

class RecentMessages extends StatelessWidget {
  var refreshMessages = RefreshController();

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      SocialCubit.get(context).getMyData();
      SocialCubit.get(context).getRecentMessages();
      SocialCubit.get(context).getFriends(SocialCubit.get(context).model!.uID);

      Future<void> onRefresh() async {
        await Future.delayed(Duration(seconds: 1));
        SocialCubit.get(context).getMyData();
        SocialCubit.get(context).getRecentMessages();
        SocialCubit.get(context).getFriends(SocialCubit.get(context).model!.uID);
        refreshMessages.refreshCompleted();
      }

      return BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) {
          List<RecentMessagesModel> recentMessages = SocialCubit.get(context).recentMessages;
          List<UserModel> friends = SocialCubit.get(context).friends;
          return WillPopScope(
            onWillPop: willPopCallback,
            child: Scaffold(
              backgroundColor: SocialCubit.get(context).backgroundColor.withOpacity(1),
              body: SmartRefresher(
                controller: refreshMessages,
                onRefresh: onRefresh,
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(height: 10,),
                      searchBar(context: context,height: 60),
                      if(friends.length > 0)
                        Container(
                          height: 112,
                          child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) =>
                              storyBuildItem(context,friends[index]),
                          separatorBuilder: (context, index) => SizedBox(height:0,),
                          itemCount: friends.length,
                      ),
                        ),
                      Conditional.single(
                            context: context,
                            conditionBuilder:(context) => recentMessages.length != 0 ,
                            widgetBuilder:(context) =>
                                ListView.separated(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) =>
                                      chatBuildItem(context,recentMessages[index]),
                                  separatorBuilder: (context, index) => SizedBox(height:0,),
                                  itemCount: recentMessages.length,
                                ),
                            fallbackBuilder: (context) => Center(
                              child: Container(
                                height: MediaQuery.of(context).size.height-200,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(Icons.chat,color: Colors.grey,size: 50,),
                                    Text(LocaleKeys.Norecentmessages.tr(),style: TextStyle(color: SocialCubit.get(context).textColor,fontWeight: FontWeight.bold,fontSize: 18),),
                                    SizedBox(height: 10,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(LocaleKeys.clickOn.tr(),style: TextStyle(color: SocialCubit.get(context).textColor),),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                          child: Icon(Icons.chat,color: Colors.grey),
                                        ),
                                        Text(LocaleKeys.tostartanewconversation.tr(),style: TextStyle(color: SocialCubit.get(context).textColor),),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            )
            ),
                    ],
                  ),
                ),
              ),
              floatingActionButton: FloatingActionButton(
                  backgroundColor: Colors.blueAccent,
                  onPressed: () {
                    SocialLayoutState.tabController.animateTo(1,duration: Duration(seconds: 1),curve: Curves.fastLinearToSlowEaseIn);
                  },
                  child: Icon(Icons.chat,)),
            ),
          );
        },
      );
    });
  }
}


Widget chatBuildItem(context,RecentMessagesModel recentMessages) {
  return InkWell(
    onTap: () {
      recentMessages.receiverId == SocialCubit.get(context).model!.uID?
      SocialCubit.get(context).readRecentMessage(recentMessages.senderId):
      SocialCubit.get(context).readRecentMessage(recentMessages.receiverId);

      recentMessages.receiverId == SocialCubit.get(context).model!.uID?
        navigateTo(context, ChatScreen(uId: recentMessages.senderId,)) :
        navigateTo(context, ChatScreen(uId: recentMessages.receiverId,));
    },
    child: Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: recentMessages.receiverId == SocialCubit.get(context).model!.uID?
            NetworkImage('${recentMessages.senderProfilePic}'):
            NetworkImage('${recentMessages.receiverProfilePic}'),
            radius: 27,
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                recentMessages.read?
                Row(
                  children: [
                    Text(
                      '${recentMessages.receiverId == SocialCubit.get(context).model!.uID?
                          recentMessages.senderName : recentMessages.receiverName}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    Text('${sinceWhen(recentMessages.time.toString())}',style: TextStyle(color: Colors.grey),)
                  ],
                ):Row(
                  children: [
                    Text(
                      '${recentMessages.receiverId == SocialCubit.get(context).model!.uID?
                      recentMessages.senderName : recentMessages.receiverName}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                        color: SocialCubit.get(context).textColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    Text('${sinceWhen(recentMessages.time.toString())}',style: TextStyle(color: SocialCubit.get(context).textColor,
                      fontWeight: FontWeight.bold,),)
                  ],
                ),
                SizedBox(height: 5,),
                recentMessages.recentMessageImage != null && recentMessages.recentMessageText !=null ?
                recentMessages.receiverId == SocialCubit.get(context).model!.uID ?
                Row (children: [
                  Icon(Icons.image_rounded,color: Colors.grey,),
                  SizedBox(width: 5,),
                  recentMessages.read?
                  Expanded(child: Text('${recentMessages.recentMessageText}',style: TextStyle(color: Colors.grey[700],)
                    ,maxLines: 1,overflow: TextOverflow.ellipsis,)) :Expanded(child: Text('${recentMessages.recentMessageText}'
                    ,style: TextStyle(color: SocialCubit.get(context).textColor,fontWeight: FontWeight.bold)
                    ,maxLines: 1,overflow: TextOverflow.ellipsis,))
                ],): Row (
                  children: [
                    Text(LocaleKeys.You.tr() + ": "),
                  Icon(Icons.image_rounded,color: Colors.grey,),
                  SizedBox(width: 5,),
                    recentMessages.read?
                    Expanded(child: Text('${recentMessages.recentMessageText}',style: TextStyle(color: Colors.grey[700],)
                      ,maxLines: 1,overflow: TextOverflow.ellipsis,)) :Expanded(child: Text('${recentMessages.recentMessageText}'
                      ,style: TextStyle(color: SocialCubit.get(context).textColor,fontWeight: FontWeight.bold)
                      ,maxLines: 1,overflow: TextOverflow.ellipsis,))
                ],)
                    : recentMessages.recentMessageImage != null ?
                recentMessages.receiverId == SocialCubit.get(context).model!.uID ?
                    recentMessages.read?
                Row (children: [
                  Icon(Icons.image_rounded),
                  SizedBox(width: 5,),
                  Text(LocaleKeys.Photo.tr(),style: TextStyle(fontSize: 16,color: Colors.grey[700])),
                ],): Row (children: [
                      Icon(Icons.image_rounded),
                      SizedBox(width: 5,),
                      Text(LocaleKeys.Photo.tr(),style: TextStyle(fontSize: 16,color: SocialCubit.get(context).textColor,fontWeight: FontWeight.bold)),
                    ],)
                    : Row (children: [
                  Text(LocaleKeys.You.tr() + ": "),
                  Icon(Icons.image_rounded,color: Colors.grey,),
                  SizedBox(width: 5,),
                  Text(LocaleKeys.Photo.tr(),style: TextStyle(fontSize: 16,color: SocialCubit.get(context).textColor),),
                ],)
                    : recentMessages.recentMessageText !=null ?
                recentMessages.receiverId == SocialCubit.get(context).model!.uID ?
                    recentMessages.read?
                Text('${recentMessages.recentMessageText}',
                  style: TextStyle(fontSize: 16,color: Colors.grey[700]),
                  maxLines: 1,overflow: TextOverflow.ellipsis,):Text('${recentMessages.recentMessageText}',
                      style: TextStyle(fontSize: 16,color: SocialCubit.get(context).textColor,fontWeight: FontWeight.bold),
                      maxLines: 1,overflow: TextOverflow.ellipsis,):
                    recentMessages.read?
                Text(LocaleKeys.You.tr() + ": " + '${recentMessages.recentMessageText}',
                    style: TextStyle(fontSize: 16,color: Colors.grey[700]),maxLines: 1,overflow: TextOverflow.ellipsis,) : Text(LocaleKeys.You.tr() + ": " + '${recentMessages.recentMessageText}',
                  style: TextStyle(fontSize: 16,color: SocialCubit.get(context).textColor,fontWeight: FontWeight.bold),maxLines: 1,overflow: TextOverflow.ellipsis,)
                    : Text('ERROR 404'),
              ],

          ),
          )
        ],
      ),
    ),
  );
}

Future<bool> willPopCallback()async {
  SocialLayoutState.tabController.animateTo(0,duration: Duration(seconds: 2),curve: Curves.fastLinearToSlowEaseIn);
  return false;
}

Widget storyBuildItem (context,UserModel users) {
  return InkWell(
    onTap: (){navigateTo(context, ChatScreen(uId: users.uID,));},
    child: Padding(
      padding: const EdgeInsetsDirectional.only(start: 15,top: 15),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: AlignmentDirectional.bottomEnd,
                children: [
                  CircleAvatar(
                    backgroundImage:NetworkImage('${users.profilePic}'),
                    radius: 27,
                  ),
                  CircleAvatar(
                    backgroundColor: SocialCubit.get(context).backgroundColor,
                    radius: 9,
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(bottom: 2,end: 2),
                    child: CircleAvatar(
                      backgroundColor: Colors.green,
                      radius: 7,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 7,),
              Container(
                width: 60,
                alignment: AlignmentDirectional.center,
                child: Text(
                  '${users.name}',
                  style:TextStyle(color: SocialCubit.get(context).textColor),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),

            ],
          ),
        ],
      ),
    ),
  );
}


