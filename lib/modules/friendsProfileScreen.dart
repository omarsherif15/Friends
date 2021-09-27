import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:socialapp/cubit/socialCubit.dart';
import 'package:socialapp/cubit/states.dart';
import 'package:socialapp/layouts/sociallayout.dart';
import 'package:socialapp/models/postModel.dart';
import 'package:socialapp/models/userModel.dart';
import 'package:socialapp/modules/searchScreen.dart';
import 'package:socialapp/shared/component.dart';
import 'package:socialapp/shared/constants.dart';
import 'package:socialapp/shared/styles/iconBroken.dart';
import 'chatScreen.dart';
import 'freindsScreen.dart';

class FriendsProfileScreen extends StatelessWidget {
  String? userUid;
  FriendsProfileScreen(this.userUid);
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      SocialCubit.get(context).getUserPosts(userUid);
      SocialCubit.get(context).getFriendsProfile(userUid);
      return BlocConsumer<SocialCubit,SocialStates>(
        listener: (context,state){
          if(state is GetFriendProfileSuccessState) {
            SocialCubit.get(context).getFriends(userUid);
            SocialCubit.get(context).checkFriends(userUid);
            SocialCubit.get(context).checkFriendRequest(userUid);
          }
        },
        builder: (context ,state) {
          UserModel? friendsModel = SocialCubit.get(context).friendsProfile;
          List<PostModel> posts = SocialCubit.get(context).userPosts;
          List<UserModel>? friends = SocialCubit.get(context).friends;
          return Conditional.single(
            context: context,
            conditionBuilder: (context) => state is GetAllUsersLoadingState || friendsModel == null,
            widgetBuilder: (context) => Center(child: CircularProgressIndicator(),),
            fallbackBuilder:(context) => Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  onPressed: (){
                    //navigateTo(context, Navigator.of(context).context.widget);
                    pop(context);
                  },
                  icon: Icon(Icons.arrow_back),
                ),
                titleSpacing: 0,
                title: Padding(
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
              ),
              body: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Container(
                    height: MediaQuery.of(context).size.height - 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children:
                      [
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
                                  decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15))),
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  child: Image.network('${friendsModel!.coverPic}', fit: BoxFit.fill, width: double.infinity,height: 190, alignment: AlignmentDirectional.topCenter,),
                                ),
                              ),
                              CircleAvatar(
                                radius: 75,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  radius: 70,
                                  backgroundImage:NetworkImage('${friendsModel.profilePic}'),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 15,),
                        Text('${friendsModel.name}',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                        SizedBox(height: 10,),
                        Text('${friendsModel.bio}'),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Text('${posts.length}',style: TextStyle(fontWeight: FontWeight.bold),),
                                    SizedBox(height: 5,),
                                    Text('Posts'),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text('12K',style: TextStyle(fontWeight: FontWeight.bold)),
                                    SizedBox(height: 5,),
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
                                      Text('${friends.length}',style: TextStyle(fontWeight: FontWeight.bold)),
                                      SizedBox(height: 5,),
                                      Text('Friends'),
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
                                      }
                                     else {
                                       showDialog(
                                           context: context,
                                           builder: (context) => alertDialog(context),
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
                                        Text('Request sent',style: TextStyle(color: Colors.white)),
                                      ],
                                    ) : Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.person_add_alt_1_rounded,color: Colors.white,),
                                        SizedBox(width: 5,),
                                        Text('Add Friend',style: TextStyle(color: Colors.white)),
                                      ],
                                    ) :
                                    Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                              Icon(Icons.person,color: Colors.black,),
                                              SizedBox(width: 5,),
                                              Text('Friends',style: TextStyle(color: Colors.black),),
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
                                        Text('Message',style: TextStyle(color: Colors.white)),
                                      ],
                                    ) :
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(IconBroken.Chat,color: Colors.black,),
                                        SizedBox(width: 5,),
                                        Text('Message',style: TextStyle(color: Colors.black),),
                                      ],
                                    )
                                ),
                              ),
                            ),
                          ],
                        ),
                        Conditional.single(
                          context: context,
                          conditionBuilder: (context) => posts.length > 0,
                          widgetBuilder:(context) => ListView.separated(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context,index) => buildPost(context,state, posts[index], friendsModel, index),
                            separatorBuilder: (context,index) => SizedBox(height: 10,),
                            itemCount:posts.length,
                          ),
                          fallbackBuilder: (context) => Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.article_outlined,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                  Text(
                                    'No Posts',
                                    style: TextStyle(
                                        fontSize: 20, fontWeight: FontWeight.bold),
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
              ),
            ),
          );
        },
      );
    });
  }
  Widget alertDialog(context){
    return AlertDialog(
      title: Text('You are already Friends'),
      content: Text('Do you want to Unfriend ?'),
      elevation: 8,
      contentPadding: EdgeInsets.all(15),
      actions: [
        OutlinedButton(
            onPressed: (){
              pop(context);
            },
            child: Text('Cancel')
        ),
        Container(
          width: 150,
          child: ElevatedButton(
            style:ButtonStyle(backgroundColor:MaterialStateProperty.all(Colors.blueAccent)) ,
            onPressed: (){
              SocialCubit.get(context).unFriend(userUid);
              SocialCubit.get(context).getFriends(userUid);
              pop(context);
            },
            child:Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person_remove),
                SizedBox(width: 5,),
                Text('Unfriend',style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ),
      ],

    );
  }
}