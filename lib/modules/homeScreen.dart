import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:socialapp/cubit/socialCubit.dart';
import 'package:socialapp/cubit/states.dart';
import 'package:socialapp/layouts/sociallayout.dart';
import 'package:socialapp/models/postModel.dart';
import 'package:socialapp/models/userModel.dart';
import 'package:socialapp/modules/newPostScreen.dart';
import 'package:socialapp/shared/component.dart';
import 'package:socialapp/shared/constants.dart';
import 'package:socialapp/shared/styles/iconBroken.dart';
import 'package:socialapp/translations/local_keys.g.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var refreshController1 = RefreshController();
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        SocialCubit.get(context).getMyData();
        SocialCubit.get(context).getPosts();
        return BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {},
          builder: (context, state) {
            UserModel? userModel = SocialCubit.get(context).model;
            List<PostModel> posts = SocialCubit.get(context).posts;
            return userModel == null  || posts.length == 0
                ? Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                  ))
                : WillPopScope(
                  onWillPop: willPop,
                  child: Scaffold(
                    key: scaffoldKey,
                      body: SmartRefresher(
                        physics: BouncingScrollPhysics(),
                        controller: refreshController1,
                        onRefresh: onRefresh,
                        child: SingleChildScrollView(
                          controller: SocialLayoutState.scrollController,
                          physics: NeverScrollableScrollPhysics(),
                          child: Column(
                            children: [
                              Card(
                                color: SocialCubit.get(context).backgroundColor,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                elevation: 8,
                                //margin: EdgeInsets.symmetric(vertical: 10),
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              navigateTo(context, SocialLayout(3));
                                            },
                                            child: CircleAvatar(
                                                radius: 22,
                                                backgroundImage:
                                                    NetworkImage('${userModel.profilePic}')),
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              navigateTo(
                                                  context,
                                                  NewPostScreen(
                                                    isEdit: false,
                                                  ));
                                            },
                                            child: Container(
                                              width: 200,
                                              child: Text(LocaleKeys.whatOnYourMind.tr(),
                                                  style: TextStyle(color: Colors.grey),
                                                textAlign: TextAlign.start,
                                              ),
                                            ),
                                          ),
                                        ],
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
                                                    SizedBox(width: 5,),
                                                    Text(LocaleKeys.image.tr(),
                                                        style: TextStyle(color: Colors.grey)),
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
                                                    Text(LocaleKeys.docs.tr(),
                                                        style: TextStyle(color: Colors.grey)),
                                                  ],
                                                )),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 5,),
                              ListView.separated(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) =>
                                    buildPost(context, state, posts[index], userModel,scaffoldKey,isSingle: false),
                                separatorBuilder: (context, index) => Container(
                                  height: 10,
                                ),
                                itemCount: posts.length,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                );
          },
        );
      },
    );
  }
  Future<bool> willPop() async {
    final shouldPop = await showDialog(
        context: context,
        builder: (context) => baseAlertDialog(
          context: context,
          title: LocaleKeys.exit.tr(),
          content: LocaleKeys.areYouSureExit.tr(),
          outlinedButtonText: 'Cancel',
          elevatedButtonText: LocaleKeys.exit.tr(),
          elevatedButtonIcon: Icons.exit_to_app_outlined,
        ));
    return shouldPop ?? false;
  }

  Future<void> onRefresh() async {
    await Future.delayed(Duration(seconds: 1)).then((value) {
      SocialCubit.get(context).getMyData();
      SocialCubit.get(context).getPosts();
      refreshController1.refreshCompleted();
    });
  }

}
