import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:socialapp/cubit/socialCubit.dart';
import 'package:socialapp/cubit/states.dart';
import 'package:socialapp/models/postModel.dart';
import 'package:socialapp/models/userModel.dart';
import 'package:socialapp/shared/component.dart';
import 'package:socialapp/shared/constants.dart';
import 'package:socialapp/shared/styles/iconBroken.dart';
import 'package:socialapp/translations/local_keys.g.dart';
import 'chatScreen.dart';
import 'freindsScreen.dart';

class FriendsProfileScreen extends StatelessWidget {
  String? userUid;
  FriendsProfileScreen(this.userUid);
  var refreshController5 = RefreshController();
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      SocialCubit.get(context).getUserPosts(userUid);
      SocialCubit.get(context).getFriendsProfile(userUid);
      SocialCubit.get(context).getFriends(userUid);
      SocialCubit.get(context).checkFriends(userUid);
      SocialCubit.get(context).checkFriendRequest(userUid);
      Future<void> onRefresh() async {
        await Future.delayed(Duration(seconds: 1));
        SocialCubit.get(context).getUserPosts(userUid);
        SocialCubit.get(context).getFriendsProfile(userUid);
        SocialCubit.get(context).getFriends(userUid);
        SocialCubit.get(context).checkFriends(userUid);
        SocialCubit.get(context).checkFriendRequest(userUid);

        refreshController5.refreshCompleted();
      }

      return BlocConsumer<SocialCubit,SocialStates>(
        listener: (context,state){},
        builder: (context ,state) {
          UserModel? friendsModel = SocialCubit.get(context).friendsProfile;
          List<PostModel>? posts = SocialCubit.get(context).userPosts;
          List<UserModel>? friends = SocialCubit.get(context).friends;
          return Conditional.single(
              context: context,
              conditionBuilder: (context) => friendsModel == null || posts == null,
              widgetBuilder: (context) => Center(child: CircularProgressIndicator(),),
              fallbackBuilder:(context) => Scaffold(
                key: scaffoldKey,
                appBar: AppBar(
                  leading: IconButton(
                    onPressed: (){
                      //navigateTo(context, Navigator.of(context).context.widget);
                      pop(context);
                    },
                    icon: Icon(Icons.arrow_back),
                  ),
                  titleSpacing: 0,
                  title: searchBar(context: context)
                ),
                body: SmartRefresher(
                  controller: refreshController5,
                  onRefresh: onRefresh,
                  child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children:
                      [
                        Container(
                          decoration: BoxDecoration(
                            color: SocialCubit.get(context).backgroundColor,
                            borderRadius: BorderRadius.circular(15)
                          ),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Column(
                            children: [
                              Container(
                                height: 250,
                                width: double.infinity,
                                alignment: AlignmentDirectional.topCenter,
                                child: Stack(
                                  alignment: AlignmentDirectional.bottomCenter,
                                  children: [
                                    Align(
                                      alignment: AlignmentDirectional.topCenter,
                                      child: Container(
                                          height: 190,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(15),
                                                  topRight: Radius.circular(15))),
                                          clipBehavior: Clip.antiAliasWithSaveLayer,
                                          child: imagePreview(friendsModel!.coverPic)
                                      ),
                                    ),
                                    CircleAvatar(
                                      radius: 75,
                                      backgroundColor: SocialCubit.get(context).backgroundColor.withOpacity(1),
                                      child: CircleAvatar(
                                          radius: 70,
                                          child: ClipRRect(
                                              borderRadius: BorderRadius.circular(70),
                                              child: imagePreview(friendsModel.profilePic))
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 15,),
                              Text('${friendsModel.name}',style: TextStyle(color: SocialCubit.get(context).textColor,fontSize: 25,fontWeight: FontWeight.bold),),
                              SizedBox(height: 10,),
                              Text('${friendsModel.bio}',style: TextStyle(color: SocialCubit.get(context).textColor,),),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Text('${posts!.length}',style: TextStyle(color: SocialCubit.get(context).textColor,fontWeight: FontWeight.bold),),
                                          SizedBox(height: 5,),
                                          Text(LocaleKeys.posts.tr(),style: TextStyle(color: SocialCubit.get(context).textColor)),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Text('12K',style: TextStyle(color: SocialCubit.get(context).textColor,fontWeight: FontWeight.bold)),
                                          SizedBox(height: 5,),
                                          Text(LocaleKeys.followers.tr(),style: TextStyle(color: SocialCubit.get(context).textColor)),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          navigateTo(
                                              context, FriendsScreen(friends));
                                        },
                                        child: Column(
                                          children: [
                                            Text('${friends.length}',style: TextStyle(color: SocialCubit.get(context).textColor,fontWeight: FontWeight.bold)),
                                            SizedBox(height: 5,),
                                            Text(LocaleKeys.profileFriends.tr(),style: TextStyle(color: SocialCubit.get(context).textColor)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ElevatedButton(
                                          style:ButtonStyle(
                                              backgroundColor: SocialCubit.get(context).isFriend == false?
                                              MaterialStateProperty.all(Colors.blueAccent)
                                                  :MaterialStateProperty.all(Colors.grey[300])
                                          ) ,
                                          onPressed: (){
                                           if(SocialCubit.get(context).isFriend == false) {
                                              SocialCubit.get(context).sendFriendRequest(
                                                  friendsUid: userUid,
                                                  friendName: friendsModel.name,
                                                  friendProfilePic: friendsModel.profilePic);
                                              SocialCubit.get(context).checkFriendRequest(userUid);
                                              SocialCubit.get(context).sendInAppNotification(
                                                contentKey: 'friendRequest',
                                                contentId: friendsModel.uID,
                                                content: 'sent you a friend request, check it out!',
                                                receiverId: friendsModel.uID,
                                                receiverName: friendsModel.name
                                              );
                                              SocialCubit.get(context).sendFCMNotification(
                                                  token: friendsModel.token,
                                                  senderName: SocialCubit.get(context).model!.name,
                                                messageText: '${SocialCubit.get(context).model!.name}' + 'sent you a friend request, check it out!'
                                              );
                                            }
                                           else {
                                             showDialog(
                                                 context: context,
                                                 builder: (context) => baseAlertDialog(
                                                   context: context,
                                                   title: 'You are already Friends',
                                                   content: 'Do you want to Unfriend ?',
                                                   outlinedButtonText:'Cancel' ,
                                                   elevatedButtonText: 'Unfriend',
                                                   elevatedButtonIcon:Icons.person_remove ,
                                                 ),
                                               barrierDismissible: true,
                                             );
                                           }
                                          },
                                          child: SocialCubit.get(context).isFriend == false? SocialCubit.get(context).request ?
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.person_add_alt_1_rounded,color: Colors.white,),
                                              SizedBox(width: 5,),
                                              Text(LocaleKeys.requestSent.tr(),style: TextStyle(color: Colors.white)),
                                            ],
                                          ) : Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.person_add_alt_1_rounded,color: Colors.white,),
                                              SizedBox(width: 5,),
                                              Text(LocaleKeys.addFriend.tr(),style: TextStyle(color: Colors.white)),
                                            ],
                                          ) :
                                          Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                    Icon(Icons.person,color: Colors.black,),
                                                    SizedBox(width: 5,),
                                                    Text(LocaleKeys.profileFriends.tr(),style: TextStyle(color: Colors.black),),
                                              ],
                                          )
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ElevatedButton(
                                        style:ButtonStyle(
                                          backgroundColor: SocialCubit.get(context).isFriend == false?
                                          MaterialStateProperty.all(Colors.grey[300])
                                              :MaterialStateProperty.all(Colors.blueAccent)
                                        ) ,
                                          onPressed: (){
                                          navigateTo(context, ChatScreen(userModel: friendsModel,));
                                          },
                                          child: SocialCubit.get(context).isFriend != false?
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(IconBroken.Chat,color: Colors.white,),
                                              SizedBox(width: 5,),
                                              Text(LocaleKeys.message.tr(),style: TextStyle(color: Colors.white)),
                                            ],
                                          ) :
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(IconBroken.Chat,color: Colors.black,),
                                              SizedBox(width: 5,),
                                              Text(LocaleKeys.message.tr(),style: TextStyle(color: Colors.black),),
                                            ],
                                          )
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10,),
                        Conditional.single(
                          context: context,
                          conditionBuilder: (context) => posts.length > 0,
                          widgetBuilder:(context) => ListView.separated(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context,index) => buildPost(context,state, posts[index], friendsModel,scaffoldKey,isSingle: false),
                            separatorBuilder: (context,index) => SizedBox(height: 10,),
                            itemCount:posts.length,
                          ),
                          fallbackBuilder: (context) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: 70,),
                                Icon(
                                  Icons.article_outlined,
                                  size: 70,
                                  color: Colors.grey,
                                ),
                                Text(
                                  'No Posts',
                                  style: TextStyle(
                                    color: SocialCubit.get(context).textColor,
                                      fontSize: 20, fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          )
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
    });
  }
}
