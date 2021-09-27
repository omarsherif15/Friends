import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/cubit/socialCubit.dart';
import 'package:socialapp/cubit/states.dart';
import 'package:socialapp/models/postModel.dart';
import 'package:socialapp/models/userModel.dart';
import 'package:socialapp/modules/editProfileScreen.dart';
import 'package:socialapp/modules/freindsScreen.dart';
import 'package:socialapp/shared/component.dart';
import 'package:socialapp/shared/constants.dart';
import 'package:socialapp/shared/styles/iconBroken.dart';
import 'newPostScreen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController commentTextControl = TextEditingController();
  var refreshKey = GlobalKey<RefreshIndicatorState>();


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
            List<PostModel> posts = SocialCubit.get(context).userPosts;
            List<UserModel>? friends = SocialCubit.get(context).friends;

            return RefreshIndicator(
              key: refreshKey,
              onRefresh: onRefresh,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
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
                                child: Image.network(
                                  '${userModel!.coverPic}',
                                  fit: BoxFit.fill,
                                  width: double.infinity,
                                  height: 190,
                                  alignment: AlignmentDirectional.topCenter,
                                ),
                              ),
                            ),
                            CircleAvatar(
                              radius: 75,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: 70,
                                backgroundImage:
                                    NetworkImage('${userModel.profilePic}'),
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
                        style:
                            TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text('${userModel.bio}'),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    '${posts.length}',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text('Posts'),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Text('12K',
                                      style:
                                          TextStyle(fontWeight: FontWeight.bold)),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text('Followers'),
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
                                    Text('${friends.length}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text('Friends'),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
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
                              Text('EDIT PROFILE'),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        margin: EdgeInsets.zero,
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
                                  navigateTo(context, NewPostScreen(isEdit: false,));
                                },
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                        radius: 22,
                                        backgroundImage: NetworkImage(
                                            '${userModel.profilePic}')),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      'What is on your mind...',
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
                                              style:
                                                  TextStyle(color: Colors.grey),
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
                                                style: TextStyle(
                                                    color: Colors.grey)),
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
                      ListView.separated(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                            return buildPost(context,state, posts[index], userModel, index);
                        },
                        separatorBuilder: (context, index) => SizedBox(height: 10,),
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
  Future<void> onRefresh() async {
    refreshKey.currentState?.show();
    await Future.delayed(Duration(seconds: 1))
        .then((value) {
      SocialCubit.get(context).getUserPosts(SocialCubit.get(context).model!.uID);
      SocialCubit.get(context).getFriends(SocialCubit.get(context).model!.uID);
    });
  }

}
