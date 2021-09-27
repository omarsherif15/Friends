import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        SocialCubit.get(context).getPosts();
        return BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {},
          builder: (context, state) {
            UserModel? userModel = SocialCubit.get(context).model;
            List<PostModel> posts = SocialCubit.get(context).posts;
            return state is UserLoadingState || state is GetPostLoadingState ||
                    posts == [] ?
                  Container(
                      child: Center(child: CircularProgressIndicator(),))
                : Scaffold(
                  body: RefreshIndicator(
                    key: refreshKey,
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
                                          onTap: (){
                                            navigateTo(context, SocialLayout(3));
                                            },
                                          child: CircleAvatar(
                                              radius: 22,
                                              backgroundImage: NetworkImage(
                                                  '${userModel!.profilePic}')),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        TextButton(
                                            onPressed: (){
                                              navigateTo(context, NewPostScreen(isEdit: false,));
                                            },
                                            child:Text('What is on your mind...',style: TextStyle(color: Colors.grey)) ,
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
                                            onPressed: () {},
                                            child: Row(
                                              children: [
                                                Icon(IconBroken.Image),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text('Image',
                                                    style: TextStyle(
                                                        color: Colors.grey)),
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
                                                  style: TextStyle(
                                                      color: Colors.grey),
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
                                                Icon(IconBroken.Document, color: Colors.green,),
                                                SizedBox(width: 5,),
                                                Text('Docs', style: TextStyle(color: Colors.grey)),
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
                            itemBuilder: (context, index) => buildPost(context,state, posts[index], userModel, index),
                            separatorBuilder: (context, index) => Container(height: 10,),
                            itemCount: posts.length,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
          },
        );
      },
    );
  }
  Future<void> onRefresh()async {
    refreshKey.currentState?.show();
    await Future.delayed(Duration(seconds: 1))
        .then((value) {
      SocialCubit.get(context).getPosts();
    });
  }
}
