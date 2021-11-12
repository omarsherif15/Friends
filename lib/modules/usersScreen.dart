import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:socialapp/cubit/socialCubit.dart';
import 'package:socialapp/cubit/states.dart';
import 'package:socialapp/layouts/sociallayout.dart';
import 'package:socialapp/models/userModel.dart';
import 'package:socialapp/modules/chatScreen.dart';
import 'package:socialapp/modules/friendsProfileScreen.dart';
import 'package:socialapp/shared/constants.dart';
import 'package:socialapp/shared/styles/iconBroken.dart';
import 'package:socialapp/translations/local_keys.g.dart';

class UsersScreen extends StatefulWidget {
  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  var refreshController = RefreshController();


  @override
  Widget build(BuildContext context) {
    return Builder(
        builder: (context) {
          SocialCubit.get(context).getFriendRequest();
          SocialCubit.get(context).getAllUsers();
          SocialCubit.get(context).getFriends(SocialCubit.get(context).model!.uID);
          return BlocConsumer<SocialCubit, SocialStates>(
            listener: (context, state) {},
            builder: (context, state) {
              List<UserModel> peopleYouMayKnow = SocialCubit.get(context).users;
              List<UserModel> friendRequests = SocialCubit.get(context).friendRequests;
              List<UserModel> friends = SocialCubit.get(context).friends;
              return WillPopScope(
                onWillPop: willPopCallback,
                child: Scaffold(
                  body: SmartRefresher(
                    controller: refreshController,
                    enablePullDown: true,
                    onRefresh: onRefresh,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 15,),
                            Text(LocaleKeys.friendRequest.tr(), style: TextStyle(fontSize: 20,color: SocialCubit.get(context).textColor, fontWeight: FontWeight.bold),),
                            //SizedBox(height: 10,),
                            Conditional.single(
                              context: context,
                              conditionBuilder: (context) =>
                              friendRequests.length > 0,
                              widgetBuilder: (context) =>
                                  ListView.separated(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) =>
                                        friendRequestBuildItem(
                                            context, friendRequests[index]),
                                    separatorBuilder: (context, index) =>
                                        SizedBox(width: 10),
                                    itemCount: friendRequests.length,
                                  ),
                              fallbackBuilder: (context) =>
                                  Container(
                                      padding: EdgeInsetsDirectional.only(
                                          top: 15, bottom: 5),
                                      alignment: AlignmentDirectional.center,
                                      child: Text(LocaleKeys.NoFriendRequest.tr(),style: TextStyle(color: SocialCubit.get(context).textColor),)),
                            ),
                            SizedBox(height: 10,),
                            Text(LocaleKeys.peopleMayKnow.tr(), style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold,color: SocialCubit.get(context).textColor)),
                            SizedBox(height: 10,),
                            Container(
                              height: 350,
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: ListView.separated(
                                physics: BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return peopleMayKnow(context, peopleYouMayKnow[index], index);
                                },
                                separatorBuilder: (context, index) =>
                                    SizedBox(width: 10),
                                itemCount: peopleYouMayKnow.length,
                              ),
                            ),
                            SizedBox(height: 10,),
                            Text(LocaleKeys.friends.tr(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: SocialCubit.get(context).textColor)),
                            SizedBox(height: 10,),
                            Conditional.single(
                              context: context,
                              conditionBuilder: (context) => friends.length > 0,
                              widgetBuilder: (context) =>
                                  ListView.separated(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) =>
                                        friendBuildItem(context, friends[index]),
                                    separatorBuilder: (context, index) =>
                                        SizedBox(height: 10,),
                                    itemCount: friends.length,
                                  ),
                              fallbackBuilder: (context) =>
                                  Container(
                                      padding: EdgeInsetsDirectional.only(
                                          top: 15, bottom: 5),
                                      alignment: AlignmentDirectional.center,
                                      child: Text(LocaleKeys.nofriends.tr(),style: TextStyle(color: SocialCubit.get(context).textColor))),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );

            },
          );
        }
    );

  }

  Future<void> onRefresh() async {
    await Future.delayed(Duration(seconds: 1));
    SocialCubit.get(context).getMyData();
    SocialCubit.get(context).getFriendRequest();
    SocialCubit.get(context).getAllUsers();
    SocialCubit.get(context).getFriends(SocialCubit.get(context).model!.uID);
    refreshController.refreshCompleted();
  }
  Future<bool> willPopCallback()async {
     SocialLayoutState.tabController.animateTo(0,duration: Duration(seconds: 2),curve: Curves.fastLinearToSlowEaseIn);
     return false;
  }

  Widget friendBuildItem(context, UserModel userModel) {
    return InkWell(
      onTap: () {
        Navigator.of(context).build(context);
        navigateTo(context, FriendsProfileScreen(userModel.uID));
      },
      child: Padding(
        padding: EdgeInsets.zero,
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage('${userModel.profilePic}'),
              radius: 27,
            ),
            SizedBox(width: 10,),
            Expanded(
              child: Text('${userModel.name}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: SocialCubit.get(context).textColor)),
            ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(
                      Colors.grey[300])),
                  onPressed: () =>
                      navigateTo(context, ChatScreen(userModel: userModel,)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(IconBroken.Chat, color: Colors.black,),
                      SizedBox(width: 5,),
                      Text(LocaleKeys.message.tr(), style: TextStyle(color: Colors.black)),
                    ],
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }

  Widget peopleMayKnow(context, UserModel userModel, index) {
    return Container(
      height: 350,
      width: 230,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color:SocialCubit.get(context).borderColor.withOpacity(1), style: BorderStyle.solid)
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
              onTap: () =>
                  navigateTo(context, FriendsProfileScreen(userModel.uID)),
              child: Image(image: NetworkImage('${userModel.profilePic}'),
                height: 200,
                width: 230,
                fit: BoxFit.cover,)),
          SizedBox(height: 10,),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${userModel.name}', style: TextStyle(fontSize: 17,color: SocialCubit.get(context).textColor)),
                SizedBox(height: 5,),
                Text('${userModel.bio}',
                  style: TextStyle(color: Colors.grey[600]),),
              ],
            ),
          ),
          SizedBox(height: 5,),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      child: ElevatedButton(
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(
                            Colors.blueAccent),
                            padding: MaterialStateProperty.all(EdgeInsets.zero)),
                        onPressed: () {
                          SocialCubit.get(context).sendFriendRequest(
                              friendsUid: userModel.uID,
                              friendName: userModel.name,
                              friendProfilePic: userModel.profilePic
                          );
                          SocialCubit.get(context).sendInAppNotification(
                              contentKey: 'friendRequest',
                              contentId: userModel.uID,
                              content: 'sent you a friend request, check it out!',
                              receiverId: userModel.uID,
                              receiverName: userModel.name
                          );
                          SocialCubit.get(context).sendFCMNotification(
                              token: userModel.token,
                              senderName: SocialCubit.get(context).model!.name,
                              messageText: '${SocialCubit.get(context).model!.name}' + 'sent you a friend request, check it out!'
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.person_add_alt_1_rounded),
                            SizedBox(width: 5,),
                            Text(LocaleKeys.addFriend.tr(), style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                  OutlinedButton(
                      onPressed: () {

                      },
                      child: Text(LocaleKeys.remove.tr())
                  ),
                ],),
            ),
          )
        ],),
    );
  }

  Widget friendRequestBuildItem(context, UserModel userModel) {
    return InkWell(
      onTap: () => navigateTo(context, FriendsProfileScreen(userModel.uID)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage('${userModel.profilePic}'),
              radius: 45,
            ),
            SizedBox(width: 10,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${userModel.name}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: SocialCubit.get(context).textColor)),
                  Text('${userModel.bio}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[600]
                    ),),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Colors.blueAccent),
                              fixedSize: MaterialStateProperty.all(
                                  Size.fromWidth(120))
                          ),
                          onPressed: () {
                            SocialCubit.get(context).addFriend(
                                friendsUid: userModel.uID,
                                friendName: userModel.name,
                                friendProfilePic: userModel.profilePic
                            );
                            SocialCubit.get(context).deleteFriendRequest(
                                userModel.uID);
                            SocialCubit.get(context).sendInAppNotification(
                                contentKey: 'friendRequestAccepted',
                                contentId: SocialCubit.get(context).model!.uID,
                                content: 'accepted your friend request, you are now friends checkout his profile',
                                receiverId: userModel.uID,
                                receiverName: userModel.name
                            );
                            SocialCubit.get(context).sendFCMNotification(
                                token: userModel.token,
                                senderName: SocialCubit.get(context).model!.name,
                                messageText: '${SocialCubit.get(context).model!.name}' + 'accepted your friend request, you are now friends checkout his profile'
                            );
                          },
                          child: Text('Confirm', style: TextStyle(
                              color: Colors.white)),
                        ),
                      ),
                      SizedBox(width: 10,),
                      Expanded(
                        child: OutlinedButton(
                            style: ButtonStyle(
                                fixedSize: MaterialStateProperty.all(
                                    Size.fromWidth(120))
                            ),
                            onPressed: () {
                              SocialCubit.get(context).deleteFriendRequest(
                                  userModel.uID);
                            },
                            child: Text('Delete')
                        ),
                      ),
                    ],)
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

}
