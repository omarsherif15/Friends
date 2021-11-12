import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:socialapp/cubit/socialCubit.dart';
import 'package:socialapp/cubit/states.dart';
import 'package:socialapp/layouts/sociallayout.dart';
import 'package:socialapp/models/postModel.dart';
import 'package:socialapp/models/userModel.dart';
import 'package:socialapp/modules/editProfileScreen.dart';
import 'package:socialapp/modules/freindsScreen.dart';
import 'package:socialapp/shared/component.dart';
import 'package:socialapp/shared/constants.dart';
import 'package:socialapp/shared/styles/iconBroken.dart';
import 'package:socialapp/translations/local_keys.g.dart';
import 'newPostScreen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController commentTextControl = TextEditingController();
  var refreshController = RefreshController();
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        SocialCubit.get(context).getUserPosts(SocialCubit.get(context).model!.uID);
        SocialCubit.get(context).getFriends(SocialCubit.get(context).model!.uID);
        return BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {},
          builder: (context, state) {
            UserModel? userModel = SocialCubit.get(context).model;
            List<PostModel>? userPosts = SocialCubit.get(context).userPosts;
            List<UserModel>? friends = SocialCubit.get(context).friends;

            return WillPopScope(
              onWillPop: willPopCallback,
              child: Conditional.single(
                context: context,
                conditionBuilder:(context)  => userModel != null ,
                widgetBuilder:(context) => Scaffold(
                  key: scaffoldKey,
                  body: SmartRefresher(
                    controller: refreshController,
                    onRefresh: onRefresh,
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              decoration: BoxDecoration(
                                  color: SocialCubit.get(context).backgroundColor,
                                  borderRadius: BorderRadius.circular(15)),
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
                                            child: imagePreview(userModel!.coverPic)
                                          ),
                                        ),
                                        CircleAvatar(
                                          radius: 75,
                                          backgroundColor: SocialCubit.get(context).backgroundColor.withOpacity(1),
                                          child: CircleAvatar(
                                            radius: 70,
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(70),
                                                child: imagePreview(userModel.profilePic))
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    '${userModel.name}',
                                    style: TextStyle(fontSize: 25,color: SocialCubit.get(context).textColor, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text('${userModel.bio}',style: TextStyle(color: SocialCubit.get(context).textColor),),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 15),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Text(
                                                '${userPosts!.length}',
                                                style: TextStyle(color: SocialCubit.get(context).textColor,fontWeight: FontWeight.bold),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(LocaleKeys.posts.tr(),style: TextStyle(color: SocialCubit.get(context).textColor),),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Text('12K', style: TextStyle(fontWeight: FontWeight.bold,color: SocialCubit.get(context).textColor)),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(LocaleKeys.followers.tr(),style: TextStyle(color: SocialCubit.get(context).textColor),),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              navigateTo(context, FriendsScreen(friends,myFreinds: true,));
                                            },
                                            child: Column(
                                              children: [
                                                Text('${friends.length}',
                                                    style: TextStyle(color: SocialCubit.get(context).textColor,fontWeight: FontWeight.bold)),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(LocaleKeys.profileFriends.tr(),style: TextStyle(color: SocialCubit.get(context).textColor),),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    width: double.infinity,
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        navigateTo(context, EditProfileScreen());
                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.edit_outlined),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(LocaleKeys.editprofile.tr()),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),

                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Card(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              margin: EdgeInsets.zero,
                              color: SocialCubit.get(context).backgroundColor,
                              elevation: 8,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        navigateTo(
                                            context,
                                            NewPostScreen(
                                              isEdit: false,
                                            ));
                                      },
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                              radius: 22,
                                              backgroundImage: NetworkImage('${userModel.profilePic}')),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Text(
                                            LocaleKeys.whatOnYourMind.tr(),
                                            style: TextStyle(color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Expanded(
                                          child: TextButton(
                                              onPressed: () {
                                                SocialCubit.get(context).getPostImage();
                                                if(SocialCubit.get(context).postImage != null)
                                                  navigateTo(context, NewPostScreen(isEdit: false));
                                              },
                                              child: Row(
                                                children: [
                                                  Icon(IconBroken.Image),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(LocaleKeys.image.tr(), style: TextStyle(color: Colors.grey)),
                                                ],
                                              )),
                                        ),
                                        Container(
                                          height: 30,
                                          width: 1,
                                          color: Colors.grey[300],
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Expanded(
                                          child: TextButton(
                                              onPressed: () {},
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.tag,
                                                    color: Colors.red,
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    LocaleKeys.tags.tr(),
                                                    style: TextStyle(color: Colors.grey),
                                                  ),
                                                ],
                                              )),
                                        ),
                                        Container(
                                          height: 30,
                                          width: 1,
                                          color: Colors.grey[300],
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Expanded(
                                          child: TextButton(
                                              onPressed: () {},
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    IconBroken.Document,
                                                    color: Colors.green,
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(LocaleKeys.docs.tr(), style: TextStyle(color: Colors.grey)),
                                                ],
                                              )),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Conditional.single(
                                context: context,
                                conditionBuilder: (context) => userPosts.length > 0,
                                widgetBuilder:(context) => ListView.separated(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context,index) => buildPost(context,state, userPosts[index], userModel,scaffoldKey,isSingle: false),
                                  separatorBuilder: (context,index) => SizedBox(height: 10,),
                                  itemCount:userPosts.length,
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
                fallbackBuilder:(context) => CircularProgressIndicator()
              ),
            );
          },
        );
      },
    );
  }

  Future<bool> willPopCallback()async {
    SocialLayoutState.tabController.animateTo(0,duration: Duration(seconds: 2),curve: Curves.fastLinearToSlowEaseIn);
    return false;
  }

  Future<void> onRefresh() async {
    await Future.delayed(Duration(seconds: 1));
    SocialCubit.get(context).getUserPosts(SocialCubit.get(context).model!.uID);
    SocialCubit.get(context).getFriends(SocialCubit.get(context).model!.uID);
    refreshController.refreshCompleted();
  }
}
