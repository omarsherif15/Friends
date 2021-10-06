import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:socialapp/cubit/socialCubit.dart';
import 'package:socialapp/cubit/states.dart';
import 'package:socialapp/layouts/sociallayout.dart';
import 'package:socialapp/models/recentMessagesModel.dart';
import 'package:socialapp/models/userModel.dart';
import 'package:socialapp/modules/chatScreen.dart';
import 'package:socialapp/modules/searchScreen.dart';
import 'package:socialapp/shared/constants.dart';

class RecentMessages extends StatelessWidget {
  var refreshController = RefreshController();

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      SocialCubit.get(context).getUserData();
      SocialCubit.get(context).getRecentMessages();
      SocialCubit.get(context).getFriends(SocialCubit.get(context).model!.uID);
      Future<void> onRefresh() async {
        await Future.delayed(Duration(seconds: 1));
        SocialCubit.get(context).getUserData();
        SocialCubit.get(context).getRecentMessages();
        SocialCubit.get(context).getFriends(SocialCubit.get(context).model!.uID);
        refreshController.refreshCompleted();
      }

      return BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) {
          List<RecentMessagesModel> recentMessages = SocialCubit.get(context).recentMessages;
          List<UserModel> friends = SocialCubit.get(context).friends;
          print(DateTime.now().toString());
          return Scaffold(
            body: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width -20,
                      child: TextFormField(
                        readOnly: true,
                        style: Theme.of(context).textTheme.bodyText1,
                        onTap: (){
                          navigateTo(context, SearchScreen());
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder( borderRadius: BorderRadius.circular(15)),
                          filled: true,
                          fillColor: Colors.grey[200],
                          disabledBorder: OutlineInputBorder( borderRadius: BorderRadius.circular(15),borderSide: BorderSide(color: Colors.grey.shade200)),
                          focusedBorder: OutlineInputBorder( borderRadius: BorderRadius.circular(15),borderSide: BorderSide(color: Colors.grey.shade200)),
                          hintText: 'Search',
                          hintStyle: TextStyle(fontSize: 15),
                          prefixIcon: Icon(Icons.search,color: Colors.grey,),
                        ),
                      ),
                    ),
                  ),
                  if(friends.length > 0)
                    Container(
                      height: 110,
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.chat,color: Colors.grey,size: 50,),
                              Text('No recent messages',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                              SizedBox(height: 10,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Click on'),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Icon(Icons.chat,color: Colors.grey),
                                  ),
                                  Text('to start a new conversation'),
                                ],
                              )
                            ],
                          ),
                        )
          ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.blueAccent,
                onPressed: () {
                  navigateAndKill(context, SocialLayout(1));
                 //print(SocialCubit.get(context).checkFriends('mi5uiCLintXWBZ6GTnDpEipOXng2'));
                },
                child: Icon(Icons.chat,)),
          );
        },
      );
    });
  }
}


Widget chatBuildItem(context,RecentMessagesModel recentMessages) {
  return InkWell(
    onTap: () {
      navigateTo(context, ChatScreen(recentMessagesModel: recentMessages));
    },
    child: Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage('${recentMessages.profilePic}'),
            radius: 27,
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '${recentMessages.receiverName}', maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    Text('${sinceWhen(recentMessages.time.toString())}',style: TextStyle(color: Colors.grey),)
                  ],
                ),
                SizedBox(height: 10,),
                recentMessages.receiverId == SocialCubit.get(context).model!.uID?
                Text('${recentMessages.recentMessageText}')
                    : Text('You: ${recentMessages.recentMessageText}')
              ],
            ),
          )
        ],
      ),
    ),
  );
}

Widget storyBuildItem (context,UserModel users) {
  return InkWell(
    onTap: (){navigateTo(context, ChatScreen(userModel: users,));},
    child: Padding(
      padding: const EdgeInsetsDirectional.only(start: 15,top: 15,end: 15),
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
                    backgroundColor: Colors.white,
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


