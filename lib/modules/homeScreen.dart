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

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var refreshController1 = RefreshController();

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        SocialCubit.get(context).getPosts();
        SocialCubit.get(context).setUserToken();
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
                      body: SmartRefresher(
                        controller: refreshController1,
                        onRefresh: onRefresh,
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              Card(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                elevation: 8,
                                margin: EdgeInsets.symmetric(vertical: 10),
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
                                            child: Text('What is on your mind...',
                                                style: TextStyle(color: Colors.grey)),
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
                                                  navigateTo(context, NewPostScreen(isEdit: false));
                                                },
                                                child: Row(
                                                  children: [
                                                    Icon(IconBroken.Image),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text('Image',
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
                                                      'Tags',
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
                                                    Text('Docs',
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
                              ListView.separated(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) =>
                                    buildPost(context, state, posts[index], userModel, index),
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
        builder: (context) => alertDialog(context));
    return shouldPop ?? false;
  }

  Future<void> onRefresh() async {
    await Future.delayed(Duration(seconds: 1)).then((value) {
      SocialCubit.get(context).getPosts();
      refreshController1.refreshCompleted();
    });
  }
  Widget alertDialog(context){
    return AlertDialog(
      title: Text('Exit'),
      titlePadding: EdgeInsetsDirectional.only(start:13,top: 15 ),
      content: Text('Are you sure you want to Exit?'),
      elevation: 8,
      contentPadding: EdgeInsets.all(15),
      actions: [
        OutlinedButton(
            onPressed: (){
              Navigator.of(context).pop(false);
            },
            child: Text('Cancel')
        ),
        Container(
          width: 100,
          child: ElevatedButton(
            style:ButtonStyle(backgroundColor:MaterialStateProperty.all(Colors.blueAccent)) ,
            onPressed: (){
              Navigator.of(context).pop(true);
              pop(context);
            },
            child:Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.exit_to_app_outlined),
                SizedBox(width: 5,),
                Text('Exit',style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ),
      ],

    );
  }
}
